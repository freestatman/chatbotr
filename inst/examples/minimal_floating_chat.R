#!/usr/bin/env Rscript

# Minimal Floating Chat Example
# This example demonstrates a basic floating chat with clear functionality

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
    class = "container mt-5",
    h1("Minimal Floating Chat Demo"),
    p("This is your main application content."),
    p("Click the floating chat button in the bottom-right corner to open the chat assistant."),
    
    div(
      class = "card mt-4",
      div(
        class = "card-body",
        h5(class = "card-title", "Features Demonstrated:"),
        tags$ul(
          tags$li("Floating chat button that opens an overlay chat panel"),
          tags$li("Clean, minimal design with light theme"),
          tags$li("Clear button in the header to reset conversation"),
          tags$li("Minimize and maximize controls"),
          tags$li("Click outside to close the chat")
        )
      )
    )
  ),
  
  # Floating chat UI with clear button
  floating_chat_ui(
    id = "my_chat",
    title = "AI Assistant",
    trigger_position = "bottom-right",
    trigger_icon = "robot",
    trigger_size = 60,
    panel_width = 400,
    panel_height = 600,
    theme = "light",
    enable_minimize = TRUE,
    enable_maximize = TRUE,
    # Add a clear button to the header
    header_actions = actionButton(
      inputId = "clear_chat",
      label = NULL,
      icon = icon("trash-alt"),
      class = "btn btn-sm btn-ghost",
      style = "padding: 4px 8px;",
      title = "Clear conversation"
    ),
    chat_ui_fun = shinychat::chat_mod_ui,
    welcome_message = "Welcome! I'm your AI assistant. How can I help you today?"
  )
)

# Server
server <- function(input, output, session) {
  
  # Floating chat server
  chat <- floating_chat_server(
    id = "my_chat",
    chat_server_fun = shinychat::chat_mod_server,
    client = ellmer::chat_github(
      system_prompt = "You are a helpful assistant for this demo app."
    )
  )
  
  # Clear chat functionality
  observeEvent(input$clear_chat, {
    # Reset the chat session
    chat$clear()
    
    # Update the chat UI by reinitializing the server
    # Note: In a production app, you might want to use a more sophisticated
    # approach to clear messages, possibly using shinychat's built-in features
    showNotification(
      "Chat cleared! Starting a new conversation.",
      type = "message",
      duration = 3
    )
  })
}

# Run the app
shinyApp(ui = ui, server = server)
