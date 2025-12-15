#!/usr/bin/env Rscript

# BYOK Offcanvas Chat Example
# Demonstrates "Bring Your Own Key" functionality with offcanvas (side panel) interface

library(shiny)
library(bslib)
library(shinychat)
library(ellmer)
library(chatbotr)
pkgload::load_all()

# UI
ui <- page_fluid(
  theme = bs_theme(version = 5, preset = "bootstrap"),

  # Main app content
  div(
    class = "container mt-4",
    h1("BYOK Offcanvas Chat Demo"),
    p(
      class = "lead",
      "Configure your own LLM provider with the offcanvas chat interface."
    ),

    # Settings card at top
    div(
      class = "card mb-4",
      div(
        class = "card-header bg-primary text-white d-flex justify-content-between align-items-center",
        h5(class = "mb-0", "API Configuration"),
        actionButton(
          inputId = "toggle_settings",
          label = NULL,
          icon = icon("chevron-down"),
          class = "btn btn-sm btn-light",
          onclick = "document.getElementById('settingsCollapse').classList.toggle('show')"
        )
      ),
      div(
        id = "settingsCollapse",
        class = "collapse",
        div(
          class = "card-body",
          api_settings_ui(
            id = "settings",
            default_provider = "github",
            show_advanced = TRUE,
            inline = FALSE
          )
        )
      )
    ),

    # Instructions
    div(
      class = "card mb-4",
      div(
        class = "card-body",
        h5(class = "card-title", "How to Use"),
        tags$ol(
          tags$li("Expand the 'API Configuration' section above"),
          tags$li("Select your preferred LLM provider"),
          tags$li("Enter your API key or token"),
          tags$li("Choose a model"),
          tags$li("Optionally adjust temperature and max tokens"),
          tags$li("Click 'Save Settings'"),
          tags$li("Click 'Test Connection' to verify"),
          tags$li("Use the 'Open Chat' button to start chatting")
        )
      )
    ),

    # Features
    div(
      class = "card mb-4",
      div(
        class = "card-body",
        h5(class = "card-title", "Supported Providers"),
        div(
          class = "row",
          div(
            class = "col-md-6",
            tags$ul(
              tags$li(tags$strong("GitHub Models"), " - Use GitHub PAT"),
              tags$li(tags$strong("OpenAI"), " - GPT-4, GPT-3.5, etc."),
              tags$li(tags$strong("Anthropic"), " - Claude 3.5, 3 Opus, etc.")
            )
          ),
          div(
            class = "col-md-6",
            tags$ul(
              tags$li(tags$strong("Google Gemini"), " - Gemini 1.5 Pro/Flash"),
              tags$li(tags$strong("Azure OpenAI"), " - Enterprise deployments"),
              tags$li(tags$strong("Ollama"), " - Local LLM inference")
            )
          )
        )
      )
    ),

    # Status indicator
    uiOutput("status_indicator")
  ),

  # Offcanvas chat
  offcanvas_chat_ui(
    id = "chat",
    title = "AI Assistant",
    placement = "end",
    width = 500,
    open_label = "Open Chat",
    open_class = "btn btn-primary",
    open_icon = "comments",
    welcome_message = "Hello! Configure your API settings first, then start chatting.",
    header_right = actionButton(
      inputId = "clear_offcanvas",
      label = NULL,
      icon = icon("trash"),
      class = "btn btn-sm btn-ghost",
      title = "Clear chat"
    )
  )
)

# Server
server <- function(input, output, session) {
  # API Settings module
  settings <- api_settings_server(
    id = "settings",
    default_system_prompt = "You are a helpful AI assistant focused on providing clear, accurate responses."
  )

  # Reactive chat instance
  chat_instance <- reactiveVal(NULL)

  # Status indicator
  output$status_indicator <- renderUI({
    if (settings$is_configured()) {
      div(
        class = "alert alert-success",
        role = "alert",
        icon("check-circle"),
        sprintf(
          " Connected to %s using model %s. Ready to chat!",
          toupper(settings$provider()),
          settings$model()
        )
      )
    } else {
      div(
        class = "alert alert-warning",
        role = "alert",
        icon("exclamation-triangle"),
        " Please configure your API settings above before starting a chat."
      )
    }
  })

  # Initialize or update chat when settings are configured
  observe({
    req(settings$is_configured())
    req(settings$client())

    # Create chat server with configured client
    offcanvas_chat_server(
      id = "chat",
      client = settings$client()
    )
  })

  # Clear chat functionality - Use shinychat::chat_clear()
  observeEvent(input$clear_offcanvas, {
    shinychat::chat_clear("chat-chat-chat")
    showNotification(
      "Conversation cleared!",
      type = "message",
      duration = 2
    )
  })
}

# Run the app
shinyApp(ui = ui, server = server)
