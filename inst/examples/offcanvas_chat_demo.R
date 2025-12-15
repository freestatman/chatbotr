library(shiny)
library(bslib)
library(ellmer)
library(shinychat)
library(chatbotr)

ui <- page_fluid(
  theme = bs_theme(version = 5), # ensure Bootstrap 5
  h3("Offcanvas Chatbot (shinychat inside)"),
  # Open-button + Offcanvas + Chat UI
  offcanvas_chat_ui(
    id = "assist",
    title = "Assistant",
    placement = "end",
    width = 420,
    open_label = "Open chat",
    open_class = "btn btn-outline-primary",
    open_icon = "comments",
    welcome_message = "Hi! I'm here to help. Ask me anything!"
    # If you need to pass additional args to shinychat's UI:
    # chat_ui_args = list(placeholder = "Type your message...")
  )
)

server <- function(input, output, session) {
  github <- ellmer::chat_github()
  # Plug in shinychat's server module here:
  offcanvas_chat_server(
    id = "assist",
    client = github
    # Pass through additional config args required by shin
    # , system_prompt = "You are a helpful assistant."
    # , model = "gpt-4o-mini"
    # , temperature = 0.2
    # , tools = list(...)
  )
}

shinyApp(ui, server)
