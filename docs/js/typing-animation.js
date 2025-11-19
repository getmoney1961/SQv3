// Typing Animation Script
document.addEventListener('DOMContentLoaded', function() {
    const textElement = document.getElementById('typingText');
    const heroContent = document.querySelector('.hero-content');
    const heroInput = document.getElementById('heroInput');
    const submitButton = document.getElementById('submitButton');
    const bubblesContainer = document.getElementById('bubblesContainer');
    const text = 'What does success mean to you?';
    let index = 0;
    const typingSpeed = 100; // milliseconds per character
    
    // Typing animation function
    function typeCharacter() {
        if (index < text.length) {
            textElement.textContent += text.charAt(index);
            index++;
            setTimeout(typeCharacter, typingSpeed);
        }
    }
    
    // Start typing animation after a brief delay
    setTimeout(typeCharacter, 500);
    
    // Firebase database reference - only initialize if Firebase is available
    let entriesRef = null;
    if (typeof database !== 'undefined') {
        entriesRef = database.ref('entries');
    }
    
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
    
    // Handle touch/tap for mobile devices
    let isTouchDevice = false;
    
    // Detect if device supports touch
    heroContent.addEventListener('touchstart', function(e) {
        isTouchDevice = true;
        
        // Toggle the active class for mobile
        if (!heroContent.classList.contains('active')) {
            heroContent.classList.add('active');
            setTimeout(() => {
                heroInput.focus();
            }, 300);
        }
    }, { passive: true });
    
    // Close input when clicking outside on mobile
    document.addEventListener('touchstart', function(e) {
        if (isTouchDevice && heroContent.classList.contains('active')) {
            // Check if the touch is outside the hero-content
            if (!heroContent.contains(e.target)) {
                heroContent.classList.remove('active');
                heroInput.blur();
            }
        }
    }, { passive: true });
    
    // Save entry to Firebase
    function saveEntry(text) {
        if (!entriesRef) {
            console.warn('Firebase not available - entry not saved');
            return;
        }
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
    
    // Track if user has submitted anything
    let userHasSubmitted = false;
    let firebaseListener = null;
    
    // Function to load all entries and start listening
    function startShowingBubbles(callback) {
        if (!entriesRef) {
            console.warn('Firebase not available - cannot show bubbles');
            if (callback) callback();
            return;
        }
        
        if (firebaseListener) {
            if (callback) callback();
            return; // Already listening
        }
        
        console.log('Starting to show bubbles...');
        
        // Load all existing entries first
        entriesRef.once('value', function(snapshot) {
            const entries = [];
            snapshot.forEach(function(childSnapshot) {
                entries.push(childSnapshot.val());
            });
            
            console.log('Loaded', entries.length, 'existing entries');
            
            // Sort by timestamp (oldest first)
            entries.sort((a, b) => a.timestamp - b.timestamp);
            
            // Create bubbles with staggered timing
            entries.forEach((entry, index) => {
                if (entry && entry.text) {
                    setTimeout(() => {
                        createBubble(entry.text);
                    }, index * 500); // 500ms delay between each bubble
                }
            });
            
            // Now listen for new entries in real-time (AFTER loading existing ones)
            const startListeningTime = Date.now();
            console.log('Starting real-time listener at:', startListeningTime);
            
            firebaseListener = entriesRef.on('child_added', function(snapshot) {
                const entry = snapshot.val();
                
                // Only show new entries added after we started listening
                if (entry && entry.text && entry.timestamp >= startListeningTime) {
                    console.log('New real-time entry:', entry.text, 'timestamp:', entry.timestamp);
                    createBubble(entry.text);
                }
            }, function(error) {
                console.error('Firebase read error:', error);
            });
            
            // Call callback after everything is set up
            if (callback) callback();
        });
    }
    
    // Handle submit button click
    submitButton.addEventListener('click', function(e) {
        e.preventDefault();
        const value = heroInput.value.trim();
        if (value) {
            // If this is the user's first submission, load all entries FIRST, then save
            if (!userHasSubmitted) {
                userHasSubmitted = true;
                console.log('First submission - loading all entries first...');
                
                // Load all entries, then save the new one after the listener is active
                startShowingBubbles(function() {
                    console.log('All entries loaded, now saving new entry:', value);
                    saveEntry(value);
                });
            } else {
                // Not first submission, save immediately
                saveEntry(value);
            }
            
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
