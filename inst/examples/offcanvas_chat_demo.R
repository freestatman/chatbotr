#!/usr/bin/env Rscript

# Offcanvas Chat Demo
# Demonstrates the offcanvas (side panel) chat interface

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

    h1("Offcanvas Chat Demo", style = "font-weight: 600;"),
    p(
      class = "text-muted",
      "Click the button below to open the chat panel."
    ),

    div(
      class = "mt-4",
      offcanvas_chat_ui(
        id = "chat",
        title = "Assistant",
        placement = "end",
        width = "30vw",
        open_label = "Open Chat",
        open_class = "btn btn-dark",
        open_icon = "comments",
        welcome_message = "Hi! How can I help you today?",
        suggested_prompts = c(
          "What is an offcanvas?",
          "Show me a ggplot example",
          "Can you summarize this page?"
        ),
        header_right = actionButton(
          inputId = "clear_chat",
          label = NULL,
          icon = icon("trash-alt"),
          class = "btn btn-sm btn-ghost",
          title = "Clear chat"
        )
      )
    ),

    div(
      class = "card mt-4",
      div(
        class = "card-body",
        h5("Features", style = "font-weight: 500;"),
        tags$ul(
          class = "mb-0",
          tags$li("Slide-out panel from any edge"),
          tags$li("Configurable width"),
          tags$li("Clear conversation button"),
          tags$li("Welcome message support")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  offcanvas_chat_server(
    id = "chat",
    client = ellmer::chat_github(
      system_prompt = "You are a helpful assistant. Be concise."
    )
  )

  observeEvent(input$clear_chat, {
    shinychat::chat_clear(id = "chat-chat-chat")
    showNotification("Chat cleared", type = "message", duration = 2)
  })
}

shinyApp(ui, server)
