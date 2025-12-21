#!/usr/bin/env Rscript

# BYOK Offcanvas Chat Demo
# Demonstrates "Bring Your Own Key" with offcanvas interface

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

    h1("BYOK Offcanvas Demo", style = "font-weight: 600;"),
    p(
      class = "text-muted",
      "Configure your API settings, then open the chat panel."
    ),

    # Settings Card
    div(
      class = "card mt-4",
      div(
        class = "card-header d-flex justify-content-between align-items-center",
        style = "background: #171717; color: #fff;",
        tags$span("API Configuration", style = "font-weight: 500;"),
        actionButton(
          inputId = "toggle_settings",
          label = NULL,
          icon = icon("chevron-down"),
          class = "btn btn-sm btn-light",
          onclick = "document.getElementById('settingsContent').classList.toggle('show')"
        )
      ),
      div(
        id = "settingsContent",
        class = "collapse show",
        div(
          class = "card-body",
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
