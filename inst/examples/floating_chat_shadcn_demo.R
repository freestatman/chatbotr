#!/usr/bin/env Rscript

# Shadcn-Style Floating Chat Demo
# Demonstrates state-of-the-art chatbot styling with shadcn/ui design system

library(shiny)
library(bslib)
library(shinyjs)
library(shinychat)
library(ellmer)
library(chatbotr)
pkgload::load_all()

# UI
ui <- page_fluid(
  theme = bs_theme(version = 5),
  useShinyjs(),
  
  # Custom styles for demo content
  tags$style(HTML("
    body {
      background: linear-gradient(to bottom, #fafafa 0%, #f4f4f5 100%);
      min-height: 100vh;
    }
    .hero-section {
      padding: 3rem 1.5rem;
      text-align: center;
      max-width: 900px;
      margin: 0 auto;
    }
    .hero-title {
      font-size: 2.5rem;
      font-weight: 700;
      letter-spacing: -0.025em;
      background: linear-gradient(135deg, #18181b 0%, #52525b 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      margin-bottom: 1rem;
    }
    .hero-description {
      font-size: 1.125rem;
      color: #71717a;
      margin-bottom: 2rem;
      line-height: 1.75;
    }
    .feature-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 1.5rem;
      margin-top: 3rem;
    }
    .feature-card {
      background: white;
      border: 1px solid #e4e4e7;
      border-radius: 0.75rem;
      padding: 1.5rem;
      transition: all 0.2s;
      box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05);
    }
    .feature-card:hover {
      border-color: #18181b;
      box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
      transform: translateY(-2px);
    }
    .feature-icon {
      width: 3rem;
      height: 3rem;
      background: #18181b;
      color: white;
      border-radius: 0.5rem;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.5rem;
      margin-bottom: 1rem;
    }
    .feature-title {
      font-weight: 600;
      font-size: 1rem;
      margin-bottom: 0.5rem;
      color: #18181b;
    }
    .feature-desc {
      font-size: 0.875rem;
      color: #71717a;
      line-height: 1.5;
    }
    .theme-switcher {
      position: fixed;
      top: 1.5rem;
      right: 1.5rem;
      z-index: 1000;
    }
    .theme-btn {
      background: white;
      border: 1px solid #e4e4e7;
      border-radius: 0.5rem;
      padding: 0.5rem 1rem;
      font-size: 0.875rem;
      font-weight: 500;
      color: #18181b;
      cursor: pointer;
      transition: all 0.2s;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }
    .theme-btn:hover {
      background: #f4f4f5;
      border-color: #18181b;
    }
  ")),
  
  # Theme switcher (for demo purposes)
  div(
    class = "theme-switcher",
    actionButton(
      "switch_theme",
      label = tagList(icon("moon"), "Dark Mode"),
      class = "theme-btn"
    )
  ),
  
  # Hero section
  div(
    class = "hero-section",
    h1(class = "hero-title", "State-of-the-Art Chat Interface"),
    p(
      class = "hero-description",
      "Experience a beautifully designed floating chat powered by shadcn/ui design principles.",
      "Clean aesthetics, smooth animations, and perfect accessibility."
    ),
    
    # Feature grid
    div(
      class = "feature-grid",
      div(
        class = "feature-card",
        div(class = "feature-icon", icon("palette")),
        div(class = "feature-title", "Modern Design"),
        div(class = "feature-desc", "Inspired by shadcn/ui with CSS variables for consistent theming")
      ),
      div(
        class = "feature-card",
        div(class = "feature-icon", icon("bolt")),
        div(class = "feature-title", "Smooth Animations"),
        div(class = "feature-desc", "Delightful micro-interactions with cubic-bezier easing functions")
      ),
      div(
        class = "feature-card",
        div(class = "feature-icon", icon("universal-access")),
        div(class = "feature-title", "Accessible"),
        div(class = "feature-desc", "ARIA labels, keyboard navigation, and focus management")
      ),
      div(
        class = "feature-card",
        div(class = "feature-icon", icon("mobile-alt")),
        div(class = "feature-title", "Responsive"),
        div(class = "feature-desc", "Perfectly adapts from mobile to desktop with smart breakpoints")
      ),
      div(
        class = "feature-card",
        div(class = "feature-icon", icon("moon")),
        div(class = "feature-title", "Dark Mode"),
        div(class = "feature-desc", "Beautiful dark theme with reduced eye strain for night usage")
      ),
      div(
        class = "feature-card",
        div(class = "feature-icon", icon("expand-arrows-alt")),
        div(class = "feature-title", "Maximize & Minimize"),
        div(class = "feature-desc", "Full control with minimize and fullscreen capabilities")
      )
    )
  ),
  
  # Floating chat UI with light theme
  floating_chat_ui(
    id = "chat_module",
    title = "AI Assistant",
    trigger_position = "bottom-right",
    trigger_icon = "comment-dots",
    trigger_size = 60,
    panel_width = 450,
    panel_height = 700,
    theme = "light",
    welcome_message = paste0(
      "👋 Hello! I'm your AI assistant.\n\n",
      "I'm powered by state-of-the-art shadcn/ui design principles. ",
      "Ask me anything or just chat!"
    ),
    header_actions = actionButton(
      NS("chat_module", "clear_chat"),
      label = NULL,
      icon = icon("trash-alt"),
      class = "btn btn-sm btn-ghost",
      title = "Clear chat history"
    )
  )
)

# Server
server <- function(input, output, session) {
  # Reactive value for theme
  current_theme <- reactiveVal("light")
  
  # Initialize chat provider once
  github <- chat_github(
    system_prompt = paste0(
      "You are a helpful AI assistant with a friendly personality. ",
      "Provide clear, concise, and accurate responses. ",
      "Use markdown formatting when appropriate."
    )
  )
  
  # Theme switcher with CSS updates
  observeEvent(input$switch_theme, {
    if (current_theme() == "light") {
      current_theme("dark")
      updateActionButton(session, "switch_theme", 
        label = "Light Mode",
        icon = icon("sun"))
      
      # Update body background and chat theme via CSS for dark mode
      runjs("
        document.body.style.background = 'linear-gradient(to bottom, #09090b 0%, #18181b 100%)';
        const panel = document.querySelector('.floating-chat-panel');
        const header = document.querySelector('.floating-chat-header');
        const body = document.querySelector('.floating-chat-body');
        const trigger = document.querySelector('.floating-chat-trigger');
        const title = document.querySelector('.floating-chat-header h5');
        const chatMessages = document.querySelectorAll('.shiny-chat-message');
        const chatInput = document.querySelector('.shiny-chat-input-container');
        
        if (panel) {
          panel.classList.remove('floating-chat-light');
          panel.classList.add('floating-chat-dark');
          panel.style.background = '#09090b';
          panel.style.color = '#fafafa';
          panel.style.borderColor = '#27272a';
        }
        if (header) {
          header.style.background = '#09090b';
          header.style.color = '#fafafa';
          header.style.borderBottomColor = '#27272a';
        }
        if (title) {
          title.style.color = '#fafafa';
        }
        if (body) {
          body.style.background = '#09090b';
          body.style.color = '#fafafa';
        }
        if (trigger) {
          trigger.classList.remove('floating-chat-light');
          trigger.classList.add('floating-chat-dark');
          trigger.style.background = '#18181b';
          trigger.style.color = '#fafafa';
        }
        if (chatInput) {
          const textarea = chatInput.querySelector('textarea');
          if (textarea) {
            textarea.style.background = '#18181b';
            textarea.style.color = '#fafafa';
            textarea.style.borderColor = '#27272a';
          }
        }
        // Update chat message colors
        chatMessages.forEach(msg => {
          msg.style.color = '#fafafa';
        });
      ")
    } else {
      current_theme("light")
      updateActionButton(session, "switch_theme", 
        label = "Dark Mode",
        icon = icon("moon"))
      
      # Update body background and chat theme via CSS for light mode
      runjs("
        document.body.style.background = 'linear-gradient(to bottom, #fafafa 0%, #f4f4f5 100%)';
        const panel = document.querySelector('.floating-chat-panel');
        const header = document.querySelector('.floating-chat-header');
        const body = document.querySelector('.floating-chat-body');
        const trigger = document.querySelector('.floating-chat-trigger');
        const title = document.querySelector('.floating-chat-header h5');
        const chatMessages = document.querySelectorAll('.shiny-chat-message');
        const chatInput = document.querySelector('.shiny-chat-input-container');
        
        if (panel) {
          panel.classList.remove('floating-chat-dark');
          panel.classList.add('floating-chat-light');
          panel.style.background = '#ffffff';
          panel.style.color = '#18181b';
          panel.style.borderColor = '#e4e4e7';
        }
        if (header) {
          header.style.background = '#ffffff';
          header.style.color = '#18181b';
          header.style.borderBottomColor = '#e4e4e7';
        }
        if (title) {
          title.style.color = '#18181b';
        }
        if (body) {
          body.style.background = '#ffffff';
          body.style.color = '#18181b';
        }
        if (trigger) {
          trigger.classList.remove('floating-chat-dark');
          trigger.classList.add('floating-chat-light');
          trigger.style.background = '#18181b';
          trigger.style.color = '#ffffff';
        }
        if (chatInput) {
          const textarea = chatInput.querySelector('textarea');
          if (textarea) {
            textarea.style.background = '#ffffff';
            textarea.style.color = '#18181b';
            textarea.style.borderColor = '#e4e4e7';
          }
        }
        // Update chat message colors
        chatMessages.forEach(msg => {
          msg.style.color = '#18181b';
        });
      ")
    }
  })
  
  # Initialize chat server once
  floating_chat_server(
    id = "chat_module",
    client = github
  )
}

# Run the app
shinyApp(ui = ui, server = server)
