(function() {
  function initFloatingChat(config) {
    const triggerId = config.triggerId;
    const panelId = config.panelId;
    const overlayId = config.overlayId;
    const trigger = document.getElementById(triggerId);
    const panel = document.getElementById(panelId);
    const overlay = document.getElementById(overlayId);
    
    if (!trigger || !panel || !overlay) {
      setTimeout(() => initFloatingChat(config), 50);
      return;
    }
    
    function openChat() {
      panel.style.display = "flex";
      panel.style.flexDirection = "column";
      overlay.style.display = "block";
      trigger.style.transform = "scale(0) rotate(-45deg)";
      trigger.style.opacity = "0";
      
      requestAnimationFrame(() => {
        panel.style.opacity = "1";
        panel.style.transform = "translateY(0) scale(1)";
        overlay.style.opacity = "1";
      });
      
      setTimeout(() => {
        const firstInput = panel.querySelector("textarea, input[type='text']");
        if (firstInput) firstInput.focus();
      }, 400);
    }
    
    trigger.addEventListener("click", openChat);
    
    trigger.addEventListener("keydown", function(e) {
      if (e.key === "Enter" || e.key === " ") {
        e.preventDefault();
        openChat();
      }
    });
    
    const closeBtn = panel.querySelector(".floating-chat-close");
    if (closeBtn) {
      closeBtn.addEventListener("click", function() {
        closeChat();
      });
    }
    
    const maximizeBtn = panel.querySelector(".floating-chat-maximize");
    if (maximizeBtn) {
      maximizeBtn.addEventListener("click", function() {
        const isMaximized = panel.getAttribute("data-maximized") === "true";
        
        if (isMaximized) {
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
          // Use Bootstrap 5 radius for consistency with CSS
          panel.style.borderRadius = "var(--bs-border-radius-lg)";
          
          panel.setAttribute("data-maximized", "false");
          maximizeBtn.innerHTML = '<i class="fa fa-expand-arrows-alt"></i>';
          maximizeBtn.setAttribute("aria-label", "Maximize chat");
        } else {
          
          panel.style.top = "0";
          panel.style.bottom = "0";
          panel.style.left = "0";
          panel.style.right = "0";
          panel.style.width = "100vw";
          panel.style.height = "100vh";
          panel.style.borderRadius = "0";
          
          panel.setAttribute("data-maximized", "true");
          maximizeBtn.innerHTML = '<i class="fa fa-compress-arrows-alt"></i>';
          maximizeBtn.setAttribute("aria-label", "Restore chat");
        }
      });
    }
    
    overlay.addEventListener("click", function() {
      closeChat();
    });
    
    document.addEventListener("keydown", function(e) {
      if (e.key === "Escape" && panel.style.display === "flex") {
        closeChat();
      }
    });
    
    function closeChat() {
      panel.style.opacity = "0";
      panel.style.transform = "translateY(20px) scale(0.95)";
      overlay.style.opacity = "0";
      
      setTimeout(() => {
        panel.style.display = "none";
        overlay.style.display = "none";
        trigger.style.transform = "scale(1) rotate(0deg)";
        trigger.style.opacity = "1";
        trigger.focus();
      }, 400);
    }
    
    const promptContainer = panel.querySelector('.suggested-prompts');
    if (promptContainer) {
      promptContainer.addEventListener('click', function(e) {
        const chip = e.target.closest('.suggested-prompt-chip');
        if (chip) {
          const promptText = chip.innerText;
          const textArea = panel.querySelector('textarea, input[type="text"]');
          if (textArea) {
             textArea.value = promptText;
             textArea.dispatchEvent(new Event('input', { bubbles: true }));
             textArea.focus();
             
             chip.style.transform = 'scale(0.95)';
             setTimeout(() => chip.style.transform = '', 150);
          }
        }
      });
    }
  }

  window.initFloatingChat = initFloatingChat;
})();
