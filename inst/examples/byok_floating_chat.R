#!/usr/bin/env Rscript

# BYOK Floating Chat Demo
# Demonstrates "Bring Your Own Key" with floating chat interface

library(shiny)
library(bslib)
library(shinychat)
library(ellmer)
library(chatbotr)
pkgload::load_all()

ui <- page_fluid(
  theme = bs_theme(version = 5),

  div(
    class = "container py-5",
    style = "max-width: 800px;",

    h1("BYOK Chat Demo", style = "font-weight: 600;"),
    p(
      class = "text-muted",
      "Configure your own API key and provider."
    ),

    div(
      class = "card mt-4",
      div(
        class = "card-body",
        h5("Instructions", style = "font-weight: 500;"),
        tags$ol(
          class = "mb-0",
          tags$li("Click the gear icon in the chat header"),
          tags$li("Select your LLM provider"),
          tags$li("Enter your API key"),
          tags$li("Choose a model and click Save")
        )
      )
    ),

    div(
      class = "card mt-3",
      div(
        class = "card-body",
        h5("Supported Providers", style = "font-weight: 500;"),
        tags$ul(
          class = "mb-0",
          tags$li(tags$strong("GitHub Models"), " - Use GitHub PAT"),
          tags$li(tags$strong("OpenAI"), " - GPT-4, GPT-3.5"),
          tags$li(tags$strong("Anthropic"), " - Claude models"),
          tags$li(tags$strong("Google"), " - Gemini models"),
          tags$li(tags$strong("Ollama"), " - Local models")
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
        tags$div(
          class = "modal-header",
          style = "border-bottom: 1px solid #e5e5e5;",
          tags$h5(
            class = "modal-title",
            style = "font-weight: 500;",
            "API Settings"
          ),
          tags$button(
            type = "button",
            class = "btn-close",
            `data-bs-dismiss` = "modal"
          )
        ),
        tags$div(
          class = "modal-body",
          api_settings_ui(
            id = "settings",
            default_provider = "github",
            show_advanced = FALSE
          )
        )
      )
    )
  ),

  tags$script(HTML("
    Shiny.addCustomMessageHandler('closeSettingsModal', function(msg) {
      var modal = bootstrap.Modal.getInstance(document.getElementById('settingsModal'));
      if (modal) modal.hide();
    });
  "))
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
