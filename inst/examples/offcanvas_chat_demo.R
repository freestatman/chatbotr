# # Run R Chatbot Application
# # Quick launcher script
#
# cat("Starting R Chatbot...\n\n")
#
# # Check if required packages are installed
# required_packages <- c("shiny", "bslib")
#
# missing_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]
#
# if (length(missing_packages) > 0) {
#   cat("Missing required packages:", paste(missing_packages, collapse = ", "), "\n")
#   cat("Please run dev/install.R first to install dependencies.\n")
#   cat("  source('dev/install.R')\n\n")
#   stop("Missing required packages")
# }
#
# # Run the Shiny app
# cat("Launching app...\n")
# shiny::runApp(launch.browser = TRUE)
pkgload::load_all()

library(shiny)
library(bslib)

# If you’re using the shinychat package, uncomment this:
# library(shinychat)
# source("R/offcanvas_chat_module.R")

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
