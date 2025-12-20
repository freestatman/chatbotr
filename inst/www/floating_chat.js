(function() {
  function initFloatingChat(config) {
    const triggerId = config.triggerId;
    const panelId = config.panelId;
    const overlayId = config.overlayId;
    const trigger = document.getElementById(triggerId);
    const panel = document.getElementById(panelId);
    const overlay = document.getElementById(overlayId);
    
    if (!trigger || !panel || !overlay) {
      // Retry initialization if elements aren't ready yet
      setTimeout(() => initFloatingChat(config), 50);
      return;
    }
    
    // Open chat function
    function openChat() {
      panel.style.display = "flex";
      panel.style.flexDirection = "column";
      overlay.style.display = "block";
      trigger.style.transform = "scale(0)";
      trigger.style.opacity = "0";
      
      // Animate in with enhanced easing
      setTimeout(() => {
        panel.style.opacity = "1";
        panel.style.transform = "scale(1) translateY(0)";
        overlay.style.opacity = "1";
      }, 10);
      
      // Focus first input in chat
      setTimeout(() => {
        const firstInput = panel.querySelector("textarea, input[type='text']");
        if (firstInput) firstInput.focus();
      }, 350);
    }
    
    // Open chat on click
    trigger.addEventListener("click", openChat);
    
    // Open chat on Enter/Space key
    trigger.addEventListener("keydown", function(e) {
      if (e.key === "Enter" || e.key === " ") {
        e.preventDefault();
        openChat();
      }
    });
    
    // Close chat
    const closeBtn = panel.querySelector(".floating-chat-close");
    if (closeBtn) {
      closeBtn.addEventListener("click", function() {
        closeChat();
      });
    }
    
    // Minimize chat
    const minimizeBtn = panel.querySelector(".floating-chat-minimize");
    if (minimizeBtn) {
      minimizeBtn.addEventListener("click", function() {
        const isMinimized = panel.getAttribute("data-minimized") === "true";
        if (isMinimized) {
          panel.style.height = config.panelHeight;
          panel.setAttribute("data-minimized", "false");
          minimizeBtn.innerHTML = '<i class="fa fa-minus"></i>';
          minimizeBtn.setAttribute("aria-label", "Minimize chat");
        } else {
          panel.style.height = "3.75rem";
          panel.setAttribute("data-minimized", "true");
          minimizeBtn.innerHTML = '<i class="fa fa-expand"></i>';
          minimizeBtn.setAttribute("aria-label", "Restore chat");
        }
      });
    }
    
    // Maximize chat
    const maximizeBtn = panel.querySelector(".floating-chat-maximize");
    if (maximizeBtn) {
      maximizeBtn.addEventListener("click", function() {
        const isMaximized = panel.getAttribute("data-maximized") === "true";
        const isMinimized = panel.getAttribute("data-minimized") === "true";
        
        if (isMaximized) {
          // Restore to original size
          const originalWidth = panel.getAttribute("data-original-width");
          const originalHeight = panel.getAttribute("data-original-height");
          const originalPosition = panel.getAttribute("data-original-position");
          const parts = originalPosition.split("-");
          const vert = parts[0];
          const horiz = parts[1];
          
          panel.style.width = originalWidth;
          panel.style.height = originalHeight;
          panel.style.top = vert === "top" ? config.panelOffset + "px" : "auto";
          panel.style.bottom = vert === "bottom" ? config.panelOffset + "px" : "auto";
          panel.style.left = horiz === "left" ? config.panelOffset + "px" : "auto";
          panel.style.right = horiz === "right" ? config.panelOffset + "px" : "auto";
          panel.style.borderRadius = "0.75rem";
          
          panel.setAttribute("data-maximized", "false");
          maximizeBtn.innerHTML = '<i class="fa fa-expand"></i>';
          maximizeBtn.setAttribute("aria-label", "Maximize chat");
        } else {
          // Restore from minimized state if needed
          if (isMinimized) {
            const originalHeight = panel.getAttribute("data-original-height");
            panel.style.height = originalHeight;
            panel.setAttribute("data-minimized", "false");
            const minBtn = panel.querySelector(".floating-chat-minimize");
            if (minBtn) {
              minBtn.innerHTML = '<i class="fa fa-minus"></i>';
              minBtn.setAttribute("aria-label", "Minimize chat");
            }
          }
          
          // Maximize to full screen
          panel.style.top = "0";
          panel.style.bottom = "0";
          panel.style.left = "0";
          panel.style.right = "0";
          panel.style.width = "100vw";
          panel.style.height = "100vh";
          panel.style.borderRadius = "0";
          
          panel.setAttribute("data-maximized", "true");
          maximizeBtn.innerHTML = '<i class="fa fa-compress"></i>';
          maximizeBtn.setAttribute("aria-label", "Restore chat");
        }
      });
    }
    
    // Close on overlay click
    overlay.addEventListener("click", function() {
      closeChat();
    });
    
    // Close on Escape key
    document.addEventListener("keydown", function(e) {
      if (e.key === "Escape" && panel.style.display === "flex") {
        closeChat();
      }
    });
    
    function closeChat() {
      panel.style.opacity = "0";
      panel.style.transform = "scale(0.95) translateY(10px)";
      overlay.style.opacity = "0";
      
      setTimeout(() => {
        panel.style.display = "none";
        overlay.style.display = "none";
        trigger.style.transform = "scale(1)";
        trigger.style.opacity = "1";
        trigger.focus();
      }, 300);
    }
    
    // Handle specific prompt clicks
    const promptContainer = panel.querySelector('.suggested-prompts');
    if (promptContainer) {
      promptContainer.addEventListener('click', function(e) {
        const chip = e.target.closest('.suggested-prompt-chip');
        if (chip) {
          const promptText = chip.innerText;
          const textArea = panel.querySelector('textarea, input[type="text"]');
          if (textArea) {
             // Set value
             textArea.value = promptText;
             // Trigger input event for Shiny binding
             textArea.dispatchEvent(new Event('input', { bubbles: true }));
             textArea.focus();
             
             // Optional: visual feedback
             chip.style.transform = 'scale(0.95)';
             setTimeout(() => chip.style.transform = '', 150);
             
             // Optional: auto-submit if desired?
             // Not enforcing auto-submit to give user chance to edit
          }
        }
      });
    }
  }

  // Export to global scope so we can call it from R
  window.initFloatingChat = initFloatingChat;
})();
