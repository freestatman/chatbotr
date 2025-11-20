#!/usr/bin/env Rscript

# BYOK Floating Chat Example
# Demonstrates "Bring Your Own Key" functionality with floating chat interface

library(shiny)
library(bslib)
library(shinychat)
library(ellmer)
pkgload::load_all()

# UI
ui <- page_fluid(
  theme = bs_theme(version = 5, preset = "bootstrap"),

  # Main app content
  div(
    class = "container mt-4",
    h1("BYOK Floating Chat Demo"),
    p(
      class = "lead",
      "Bring Your Own Key: Configure your preferred LLM provider and API key."
    ),

    div(
      class = "card mt-4",
      div(
        class = "card-header bg-primary text-white",
        h5(class = "mb-0", "How to Use")
      ),
      div(
        class = "card-body",
        tags$ol(
          tags$li("Click the settings button (gear icon) in the floating chat"),
          tags$li("Select your preferred LLM provider"),
          tags$li("Enter your API key or token"),
          tags$li("Choose a model from the available options"),
          tags$li("Click 'Save Settings' to apply"),
          tags$li("Optionally test the connection before chatting")
        ),
        tags$hr(),
        tags$h6("Supported Providers:"),
        tags$ul(
          tags$li(
            tags$strong("GitHub Models:"),
            " Use your GitHub personal access token"
          ),
          tags$li(tags$strong("OpenAI:"), " Use your OpenAI API key"),
          tags$li(tags$strong("Anthropic:"), " Use your Anthropic API key"),
          tags$li(tags$strong("Google Gemini:"), " Use your Google API key"),
          tags$li(
            tags$strong("Azure OpenAI:"),
            " Provide endpoint and API key"
          ),
          tags$li(tags$strong("Ollama:"), " Connect to local Ollama instance")
        )
      )
    ),

    div(
      class = "card mt-4",
      div(
        class = "card-body",
        h5(class = "card-title", "Features Demonstrated:"),
        tags$ul(
          tags$li("User-configurable LLM provider and model selection"),
          tags$li("Secure API key input (stored only in session)"),
          tags$li("Connection testing before use"),
          tags$li(
            "Multiple provider support (OpenAI, Anthropic, Google, etc.)"
          ),
          tags$li("Settings accessible via gear icon in chat header"),
          tags$li("Clear button to reset conversation")
        )
      )
    )
  ),

  # Floating chat UI with settings and clear button
  floating_chat_ui(
    id = "my_chat1",
    title = "AI Assistant (BYOK)",
    trigger_position = "bottom-right",
    trigger_icon = "robot",
    trigger_size = 60,
    panel_width = 450,
    panel_height = 650,
    theme = "light",
    enable_minimize = TRUE,
    enable_maximize = TRUE,
    header_actions = tagList(
      # Settings button that opens a modal
      actionButton(
        inputId = "open_settings",
        label = NULL,
        icon = icon("cog"),
        class = "btn btn-sm btn-ghost",
        style = "padding: 4px 8px;",
        title = "Configure API Settings",
        `data-bs-toggle` = "modal",
        `data-bs-target` = "#settingsModal"
      ),
      # Clear chat button
      actionButton(
        inputId = "clear_chat",
        label = NULL,
        icon = icon("trash-alt"),
        class = "btn btn-sm btn-ghost",
        style = "padding: 4px 8px;",
        title = "Clear conversation"
      )
    ),
    welcome_message = "Welcome! Please configure your API settings using the gear icon to get started."
  ),

  # Settings Modal
  tags$div(
    class = "modal fade",
    id = "settingsModal",
    tabindex = "-1",
    `aria-labelledby` = "settingsModalLabel",
    `aria-hidden` = "true",
    tags$div(
      class = "modal-dialog modal-dialog-centered",
      tags$div(
        class = "modal-content",
        tags$div(
          class = "modal-header",
          tags$h5(
            class = "modal-title",
            id = "settingsModalLabel",
            "API Settings"
          ),
          tags$button(
            type = "button",
            class = "btn-close",
            `data-bs-dismiss` = "modal",
            `aria-label` = "Close"
          )
        ),
        tags$div(
          class = "modal-body",
          api_settings_ui(
            id = "settings",
            default_provider = "github",
            show_advanced = FALSE,
            inline = FALSE
          )
        ),
        tags$div(
          class = "modal-footer",
          tags$button(
            type = "button",
            class = "btn btn-secondary",
            `data-bs-dismiss` = "modal",
            "Close"
          )
        )
      )
    )
  ),

  # JavaScript for modal control
  tags$script(HTML(
    "
    Shiny.addCustomMessageHandler('closeSettingsModal', function(message) {
      var modal = bootstrap.Modal.getInstance(document.getElementById('settingsModal'));
      if (modal) {
        modal.hide();
      }
    });
  "
  ))
)

# Server
server <- function(input, output, session) {
  # API Settings module
  settings <- api_settings_server(
    id = "settings",
    default_system_prompt = "You are a helpful AI assistant."
  )

  # Initialize or update chat when settings are configured
  observe({
    req(settings$is_configured())
    req(settings$client())

    # Create chat server with configured client
    floating_chat_server(
      id = "my_chat1",
      client = settings$client()
    )

    # Show success notification
    showNotification(
      sprintf(
        "Chat configured with %s (%s)",
        settings$provider(),
        settings$model()
      ),
      type = "message",
      duration = 3
    )
  })

  # Clear chat functionality - Use shinychat::chat_clear()
  observeEvent(input$clear_chat, {
    # The chat ID is namespaced: module ID "my_chat" + nested chat ID "chat"
    shinychat::chat_clear(
      id = "my_chat1-chat-chat"
    )

    showNotification(
      "Chat cleared! Starting a new conversation.",
      type = "message",
      duration = 2
    )
  })

  # Show notification when settings button is clicked
  observeEvent(input$open_settings, {
    # Modal is opened via Bootstrap data attributes
  })
}

# Run the app
shinyApp(ui = ui, server = server)
