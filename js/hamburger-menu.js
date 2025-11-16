// Hamburger Menu Toggle Functionality
document.addEventListener('DOMContentLoaded', function() {
    const hamburgerMenu = document.getElementById('hamburgerMenu');
    const mobileNavOverlay = document.getElementById('mobileNavOverlay');
    const mobileNavClose = document.getElementById('mobileNavClose');
    const mobileNavLinks = document.querySelectorAll('.mobile-nav-link');
    const mobileNavDownload = document.querySelector('.mobile-nav-download');
    
    // Toggle menu on hamburger click
    hamburgerMenu.addEventListener('click', function() {
        const isActive = this.classList.contains('active');
        
        if (isActive) {
            closeMenu();
        } else {
            openMenu();
        }
    });
    
    // Close menu on close button click
    mobileNavClose.addEventListener('click', function() {
        closeMenu();
    });
    
    // Close menu when clicking on a nav link
    mobileNavLinks.forEach(link => {
        link.addEventListener('click', function() {
            closeMenu();
        });
    });
    
    // Close menu when clicking download button
    if (mobileNavDownload) {
        mobileNavDownload.addEventListener('click', function() {
            closeMenu();
        });
    }
    
    // Close menu when clicking outside (on overlay background)
    mobileNavOverlay.addEventListener('click', function(e) {
        if (e.target === mobileNavOverlay) {
            closeMenu();
        }
    });
    
    // Close menu on escape key press
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && hamburgerMenu.classList.contains('active')) {
            closeMenu();
        }
    });
    
    function openMenu() {
        hamburgerMenu.classList.add('active');
        mobileNavOverlay.classList.add('active');
        document.body.style.overflow = 'hidden'; // Prevent scrolling when menu is open
    }
    
    function closeMenu() {
        hamburgerMenu.classList.remove('active');
        mobileNavOverlay.classList.remove('active');
        document.body.style.overflow = ''; // Restore scrolling
    }
});

