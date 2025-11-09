# Example: Floating Chat Module Demo
#
# This example demonstrates the floating chat module with various configurations

library(shiny)
library(bslib)

# Demo UI with floating chat
ui <- page_fluid(
  theme = bs_theme(
    version = 5,
    bootswatch = "flatly"
  ),

  # Include Font Awesome and custom CSS
  tags$head(
    tags$link(
      rel = "stylesheet",
      href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    ),
    tags$link(
      rel = "stylesheet",
      href = "floating_chat.css"
    )
  ),

  # Main application content
  titlePanel("Floating Chat Module Demo"),

  fluidRow(
    column(
      12,
      h3("Welcome to the Floating Chat Demo"),
      p(
        "This demo showcases the floating chat module with different configurations."
      ),
      p(
        "Click the floating chat button in the bottom-right corner to start chatting!"
      )
    )
  ),

  fluidRow(
    column(
      6,
      card(
        card_header("Feature Highlights"),
        card_body(
          tags$ul(
            tags$li("Floating trigger icon with smooth animations"),
            tags$li("Customizable positioning (4 corners available)"),
            tags$li("Dark and light theme support"),
            tags$li("Minimize/expand functionality"),
            tags$li("Click-outside-to-close overlay"),
            tags$li("Responsive mobile design"),
            tags$li("Modern shadcn/ui inspired styling")
          )
        )
      )
    ),
    column(
      6,
      card(
        card_header("Configuration"),
        card_body(
          selectInput(
            "position",
            "Trigger Position:",
            choices = c(
              "Bottom Right" = "bottom-right",
              "Bottom Left" = "bottom-left",
              "Top Right" = "top-right",
              "Top Left" = "top-left"
            ),
            selected = "bottom-right"
          ),
          selectInput(
            "theme_select",
            "Theme:",
            choices = c("Light" = "light", "Dark" = "dark"),
            selected = "light"
          ),
          p(
            class = "text-muted",
            "Note: Changing these settings requires reloading the app."
          )
        )
      )
    )
  ),

  fluidRow(
    column(
      12,
      card(
        card_header("Sample Content"),
        card_body(
          h4("Interactive Dashboard"),
          plotOutput("sample_plot", height = "300px"),
          hr(),
          fluidRow(
            column(
              4,
              value_box(
                title = "Total Users",
                value = "1,234",
                showcase = icon("users"),
                theme = "primary"
              )
            ),
            column(
              4,
              value_box(
                title = "Revenue",
                value = "$45.6K",
                showcase = icon("dollar-sign"),
                theme = "success"
              )
            ),
            column(
              4,
              value_box(
                title = "Engagement",
                value = "87%",
                showcase = icon("chart-line"),
                theme = "info"
              )
            )
          )
        )
      )
    )
  ),

  # Floating chat module
  floating_chat_ui(
    id = "demo_chat",
    title = "AI Assistant",
    trigger_position = "bottom-right",
    trigger_icon = "comments",
    panel_width = 400,
    panel_height = 700,
    theme = "light",
    enable_minimize = TRUE,
    header_actions = actionButton(
      "clear_demo_chat",
      icon("trash"),
      class = "btn btn-sm btn-ghost",
      title = "Clear chat"
    ),
    chat_ui_fun = shinychat::chat_mod_ui
    # chat_ui_fun = function(id) {
    #   # Simple chat UI for demo purposes
    #   # Replace with shinychat::chat_ui or shinychat::chat_mod_ui in production
    #   ns <- NS(id)
    #   tagList(
    #     div(
    #       id = ns("messages"),
    #       style = "flex: 1; overflow-y: auto; padding: 20px;",
    #       div(
    #         class = "alert alert-info",
    #         strong("Demo Mode:"),
    #         " This is a demo UI. Integrate with shinychat for full functionality."
    #       )
    #     ),
    #
    #     div(
    #       style = "padding: 16px; border-top: 1px solid #e2e8f0;",
    #       textInput(
    #         ns("message_input"),
    #         NULL,
    #         placeholder = "Type your message...",
    #         width = "100%"
    #       ),
    #       actionButton(
    #         ns("send_btn"),
    #         "Send",
    #         icon = icon("paper-plane"),
    #         class = "btn btn-primary w-100"
    #       )
    #     )
    #   )
    # }
  )
)

# Demo server
server <- function(input, output, session) {
  # Sample plot
  output$sample_plot <- renderPlot({
    x <- seq(0, 10, length.out = 100)
    y <- sin(x) + rnorm(100, 0, 0.1)
    plot(
      x,
      y,
      type = "l",
      col = "#667eea",
      lwd = 2,
      main = "Sample Data Visualization",
      xlab = "Time",
      ylab = "Value"
    )
    grid()
  })

  # In production, use:
  floating_chat_server(
    id = "demo_chat",
    chat_server_fun = shinychat::chat_mod_server,
    client = ellmer::chat_github(
      system_prompt = "You are a helpful assistant for this demo app."
    )
  )

  # # Demo chat server logic
  # moduleServer("demo_chat", function(input, output, session) {
  #   # Simple echo server for demo
  #   observeEvent(input$chat.send_btn, {
  #     message <- input$chat.message_input
  #     if (nzchar(message)) {
  #       showNotification(
  #         paste("You said:", message),
  #         type = "message",
  #         duration = 3
  #       )
  #     }
  #   })
  # })

  # Clear chat handler
  observeEvent(input$clear_demo_chat, {
    showNotification("Chat cleared!", type = "message", duration = 2)
  })
}

# Run the app
shinyApp(ui, server)
