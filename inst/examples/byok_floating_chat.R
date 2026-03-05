#!/usr/bin/env Rscript

# BYOK Floating Chat Demo
# Demonstrates "Bring Your Own Key" with floating chat interface

library(shiny)
library(bslib)
library(shinychat)
library(ellmer)
# library(chatbotr)
pkgload::load_all()

ui <- page_fluid(
  theme = bs_theme(version = 5),

  div(
    class = "container py-5",
    style = "max-width: 800px;",

    h1(
      "BYOK Chat Demo",
      style = "font-weight: 700; letter-spacing: -0.02em; color: #0f172a;"
    ),
    p(
      class = "lead",
      style = "font-weight: 400; color: #64748b;",
      "Configure your own API key and provider for a bespoke AI experience."
    ),

    div(
      class = "mt-5",
      style = "display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;",
      div(
        class = "p-4",
        style = "background: #f8fafc; border-radius: 1.25rem; border: 1px solid #e2e8f0;",
        h5("Instructions", style = "font-weight: 600; margin-bottom: 1rem;"),
        tags$ol(
          class = "mb-0",
          style = "color: #475569; line-height: 1.6;",
          tags$li("Click the gear icon in the chat header"),
          tags$li("Select your LLM provider"),
          tags$li("Enter your API key"),
          tags$li("Choose a model and click Save")
        )
      ),
      div(
        class = "p-4",
        style = "background: #f8fafc; border-radius: 1.25rem; border: 1px solid #e2e8f0;",
        h5(
          "Supported Providers",
          style = "font-weight: 600; margin-bottom: 1rem;"
        ),
        tags$ul(
          class = "mb-0",
          style = "list-style: none; padding-left: 0; color: #475569; line-height: 1.6;",
          tags$li(
            icon("check", class = "text-primary me-2"),
            tags$strong("GitHub Models")
          ),
          tags$li(
            icon("check", class = "text-primary me-2"),
            tags$strong("OpenAI")
          ),
          tags$li(
            icon("check", class = "text-primary me-2"),
            tags$strong("Anthropic")
          ),
          tags$li(
            icon("check", class = "text-primary me-2"),
            tags$strong("Google Gemini")
          )
        )
      )
    )
  ),

  floating_chat_ui(
    id = "chat",
    title = "AI Assistant",
    trigger_position = "bottom-right",
    trigger_icon = "robot",
    panel_width = "30vw",
    panel_height = "85vh",
    theme = "light",
    welcome_message = "Configure your API settings using the gear icon to get started.",
    suggested_prompts = c(
      "How do I set my API key?",
      "Which models are supported?",
      "Tell me a joke"
    ),
    header_actions = tagList(
      actionButton(
        inputId = "open_settings",
        label = NULL,
        icon = icon("cog"),
        class = "btn btn-sm btn-ghost",
        title = "Settings",
        `data-bs-toggle` = "modal",
        `data-bs-target` = "#settingsModal"
      ),
      actionButton(
        inputId = "clear_chat",
        label = NULL,
        icon = icon("trash-alt"),
        class = "btn btn-sm btn-ghost",
        title = "Clear"
      )
    )
  ),

  # Settings Modal
  tags$div(
    class = "modal fade",
    id = "settingsModal",
    tabindex = "-1",
    tags$div(
      class = "modal-dialog modal-dialog-centered",
      tags$div(
        class = "modal-content",
        style = "border-radius: 1.5rem; border: none; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25); max-height: calc(100vh - 3.5rem); display: flex; flex-direction: column;",
        tags$div(
          class = "modal-header",
          style = "border-bottom: 1px solid #f1f5f9; padding: 1.25rem 1.5rem; flex-shrink: 0;",
          tags$h5(
            class = "modal-title",
            style = "font-weight: 600; letter-spacing: -0.01em;",
            "API Configuration"
          ),
          tags$button(
            type = "button",
            class = "btn-close",
            `data-bs-dismiss` = "modal"
          )
        ),
        tags$div(
          class = "modal-body",
          style = "padding: 1.5rem; overflow-y: auto;",
          api_settings_ui(
            id = "settings",
            default_provider = "github",
            show_advanced = FALSE
          )
        )
      )
    )
  ),

  tags$script(HTML(
    "
    Shiny.addCustomMessageHandler('closeSettingsModal', function(msg) {
      var modal = bootstrap.Modal.getInstance(document.getElementById('settingsModal'));
      if (modal) modal.hide();
    });
  "
  ))
)

server <- function(input, output, session) {
  settings <- api_settings_server(
    id = "settings",
    default_system_prompt = "You are a helpful AI assistant."
  )

  observe({
    req(settings$is_configured())
    req(settings$client())

    floating_chat_server(id = "chat", client = settings$client())

    showNotification(
      sprintf("Connected to %s", settings$provider()),
      type = "message",
      duration = 2
    )
  })

  observeEvent(input$clear_chat, {
    shinychat::chat_clear(id = "chat-chat-chat")
    showNotification("Chat cleared", type = "message", duration = 2)
  })
}

shinyApp(ui, server)
