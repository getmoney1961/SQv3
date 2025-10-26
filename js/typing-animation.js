// Typing Animation Script
document.addEventListener('DOMContentLoaded', function() {
    const textElement = document.getElementById('typingText');
    const heroContent = document.querySelector('.hero-content');
    const heroInput = document.getElementById('heroInput');
    const submitButton = document.getElementById('submitButton');
    const bubblesContainer = document.getElementById('bubblesContainer');
    const text = 'What does the word success mean to you?';
    let index = 0;
    const typingSpeed = 100; // milliseconds per character
    
    // Firebase database reference
    const entriesRef = database.ref('entries');
    
    function typeCharacter() {
        if (index < text.length) {
            textElement.textContent += text.charAt(index);
            index++;
            setTimeout(typeCharacter, typingSpeed);
        }
    }
    
    // Start typing animation after a brief delay
    setTimeout(typeCharacter, 500);
    
    // Auto-resize textarea function
    function autoResize() {
        heroInput.style.height = 'auto';
        heroInput.style.height = heroInput.scrollHeight + 'px';
    }
    
    // Auto-resize on input
    heroInput.addEventListener('input', autoResize);
    
    // Auto-focus input on hover
    heroContent.addEventListener('mouseenter', function() {
        setTimeout(() => {
            heroInput.focus();
        }, 300); // Wait for transition
    });
    
    // Save entry to Firebase
    function saveEntry(text) {
        const newEntryRef = entriesRef.push();
        newEntryRef.set({
            text: text,
            timestamp: firebase.database.ServerValue.TIMESTAMP
        }).catch(error => {
            console.error('Error saving entry:', error);
        });
    }
    
    // Create a floating bubble
    function createBubble(text) {
        const bubble = document.createElement('div');
        bubble.className = 'floating-bubble';
        bubble.textContent = text;
        
        // Random horizontal position
        const randomX = Math.random() * 100;
        bubble.style.left = randomX + '%';
        
        // Random horizontal drift (-200px to 200px)
        const floatX = (Math.random() - 0.5) * 400;
        const floatRotate = (Math.random() - 0.5) * 30;
        bubble.style.setProperty('--float-x', floatX + 'px');
        bubble.style.setProperty('--float-rotate', floatRotate + 'deg');
        
        // Random animation duration (15-25 seconds)
        const duration = 15 + Math.random() * 10;
        bubble.style.animationDuration = duration + 's';
        
        // Random delay for staggered effect
        const delay = Math.random() * 2;
        bubble.style.animationDelay = delay + 's';
        
        bubblesContainer.appendChild(bubble);
        
        // Remove bubble after animation completes
        setTimeout(() => {
            bubble.remove();
        }, (duration + delay) * 1000);
    }
    
    // Listen for new entries from Firebase (real-time)
    // Only listen for entries added after the page loads
    let isInitialLoad = true;
    
    entriesRef.limitToLast(50).on('child_added', function(snapshot) {
        // Skip the initial data load to avoid showing old entries as bubbles
        if (isInitialLoad) {
            // Give a small delay to mark initial load complete
            setTimeout(() => {
                isInitialLoad = false;
            }, 1000);
            return;
        }
        
        const entry = snapshot.val();
        if (entry && entry.text) {
            // Create a bubble for the new entry
            createBubble(entry.text);
        }
    });
    
    // Handle submit button click
    submitButton.addEventListener('click', function(e) {
        e.preventDefault();
        const value = heroInput.value.trim();
        if (value) {
            // Save the entry to Firebase
            saveEntry(value);
            
            // Create a bubble with the new entry immediately for the user
            createBubble(value);
            
            // Clear the input
            heroInput.value = '';
            
            // Reset height
            heroInput.style.height = 'auto';
            
            // Optional: Show a brief success feedback
            heroInput.placeholder = "Submitted! Type another...";
            setTimeout(() => {
                heroInput.placeholder = "Type something...";
            }, 2000);
        }
    });
    
    // Handle Enter key - submit instead of new line
    heroInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            submitButton.click();
        }
    });
});
