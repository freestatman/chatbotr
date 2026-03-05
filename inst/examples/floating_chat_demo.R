#!/usr/bin/env Rscript

# Floating Chat Demo
# Demonstrates the floating chat interface with minimal design

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

    h1("Floating Chat Demo", style = "font-weight: 600;"),
    p(
      class = "text-muted",
      "Click the button in the bottom-right corner to open the chat."
    ),

    div(
      class = "card mt-4",
      div(
        class = "card-body",
        h5("Features", style = "font-weight: 500;"),
        tags$ul(
          class = "mb-0",
          tags$li("Floating trigger button"),
          tags$li("Overlay chat panel"),
          tags$li("Minimize and maximize controls"),
          tags$li("Suggested prompts"),
          tags$li("Clear conversation button")
        )
      )
    )
  ),

  floating_chat_ui(
    id = "chat",
    title = "Assistant",
    trigger_position = "bottom-right",
    trigger_icon = "comments",
    panel_width = "30vw",
    panel_height = "85vh",
    theme = "light",
    welcome_message = "Hello! How can I help you today?",
    suggested_prompts = c(
      "Tell me a joke",
      "Explain R in one sentence",
      "What can you do?"
    ),
    header_actions = actionButton(
      inputId = "clear_chat",
      label = NULL,
      icon = icon("trash-alt"),
      class = "btn btn-sm btn-ghost",
      title = "Clear conversation"
    )
  )
)

server <- function(input, output, session) {
  floating_chat_server(
    id = "chat",
    client = ellmer::chat_github(
      model = "gpt-5-mini",
      system_prompt = "You are a helpful assistant. Be concise."
    )
  )

  observeEvent(input$clear_chat, {
    shinychat::chat_clear(id = "chat-chat-chat", session = session)
    showNotification("Chat cleared", type = "message", duration = 2)
  })
}

shinyApp(ui, server)
