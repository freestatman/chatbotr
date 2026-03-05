#!/usr/bin/env Rscript

# BYOK Offcanvas Chat Demo
# Demonstrates "Bring Your Own Key" with offcanvas interface

pkgload::load_all()
library(shiny)
library(bslib)
library(shinychat)
library(ellmer)
library(chatbotr)

ui <- page_fluid(
  theme = bs_theme(version = 5),

  div(
    class = "container py-5",
    style = "max-width: 800px;",

    h1("BYOK Offcanvas Demo", style = "font-weight: 700; letter-spacing: -0.02em;"),
    p(
      class = "lead",
      style = "color: #64748b;",
      "Configure your API settings, then open the chat panel."
    ),

    # Settings Card
    div(
      class = "mt-5",
      style = "background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(10px); border-radius: 1.5rem; border: 1px solid #e2e8f0; overflow: hidden; box-shadow: 0 10px 30px -10px rgba(0, 0, 0, 0.05);",
      div(
        class = "d-flex justify-content-between align-items-center p-4",
        style = "border-bottom: 1px solid #f1f5f9;",
        tags$span("API Configuration", style = "font-weight: 600; font-size: 1.1rem;"),
        actionButton(
          inputId = "toggle_settings",
          label = NULL,
          icon = icon("chevron-down"),
          class = "btn btn-sm btn-light",
          style = "border-radius: 0.5rem;",
          onclick = "document.getElementById('settingsContent').classList.toggle('show')"
        )
      ),
      div(
        id = "settingsContent",
        class = "collapse show",
        div(
          class = "p-4",
          api_settings_ui(
            id = "settings",
            default_provider = "github",
            show_advanced = TRUE
          )
        )
      )
    ),

    # Status
    uiOutput("status"),

    # Chat button
    div(
      class = "mt-4",
      offcanvas_chat_ui(
        id = "chat",
        title = "AI Assistant",
        placement = "end",
        width = "30vw",
        open_label = "Open Chat",
        open_class = "btn btn-dark",
        open_icon = "comments",
        welcome_message = "Configure your API settings first.",
        suggested_prompts = c(
          "I need help with settings",
          "What is BYOK?",
          "Can you write R code?"
        ),
        header_right = actionButton(
          inputId = "clear_chat",
          label = NULL,
          icon = icon("trash-alt"),
          class = "btn btn-sm btn-ghost",
          title = "Clear"
        )
      )
    )
  )
)

server <- function(input, output, session) {
  settings <- api_settings_server(
    id = "settings",
    default_system_prompt = "You are a helpful AI assistant."
  )

  output$status <- renderUI({
    if (settings$is_configured()) {
      div(
        class = "alert alert-success mt-3",
        icon("check-circle"),
        sprintf(" Ready! Using %s.", settings$provider())
      )
    } else {
      div(
        class = "alert alert-warning mt-3",
        icon("exclamation-triangle"),
        " Configure your API settings above."
      )
    }
  })

  observe({
    req(settings$is_configured())
    req(settings$client())
    offcanvas_chat_server(id = "chat", client = settings$client())
  })

  observeEvent(input$clear_chat, {
    shinychat::chat_clear(id = "chat-chat-chat")
    showNotification("Chat cleared", type = "message", duration = 2)
  })
}

shinyApp(ui, server)
