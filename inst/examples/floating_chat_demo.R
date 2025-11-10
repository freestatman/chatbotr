# Example: Floating Chat Module Demo
#
# This example demonstrates the floating chat module with various configurations
pkgload::load_all()

library(shiny)
library(bslib)

# Demo UI with floating chat
ui <- page_fluid(
  theme = bs_theme(
    version = 5,
    bootswatch = "flatly",
    primary = "#667eea",
    base_font = font_google("Inter")
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
    ),
    tags$style(HTML("
      .page-title {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 2rem 0;
        margin: -1rem -1rem 2rem -1rem;
        border-radius: 0 0 1rem 1rem;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
      }
      .feature-card {
        transition: transform 0.2s;
        height: 100%;
      }
      .feature-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 16px rgba(0,0,0,0.1);
      }
      .stat-card {
        text-align: center;
        padding: 1rem;
      }
    "))
  ),

  # Hero section
  div(
    class = "page-title text-center",
    h1("AI Assistant Demo", style = "margin: 0; font-weight: 600;"),
    p("Experience modern floating chat interface with AI-powered conversations", 
      style = "margin: 0.5rem 0 0 0; opacity: 0.9;")
  ),

  # Quick instructions
  div(
    class = "alert alert-info mb-4",
    style = "border-left: 4px solid #667eea;",
    icon("circle-info"),
    strong(" Quick Start: "),
    "Click the robot icon in the bottom-right corner to open the AI chat assistant."
  ),

  # Main content grid
  layout_columns(
    col_widths = c(5, 7),
    
    # Left column - Features
    card(
      class = "feature-card",
      card_header(
        class = "bg-primary text-white",
        icon("star"), " Feature Highlights"
      ),
      card_body(
        tags$div(
          style = "display: grid; gap: 0.75rem;",
          tags$div(
            icon("magic", class = "text-primary"), 
            " Smooth animations and transitions"
          ),
          tags$div(
            icon("location-dot", class = "text-success"), 
            " Customizable positioning (4 corners)"
          ),
          tags$div(
            icon("palette", class = "text-info"), 
            " Dark and light theme support"
          ),
          tags$div(
            icon("window-minimize", class = "text-warning"), 
            " Minimize/maximize functionality"
          ),
          tags$div(
            icon("hand-pointer", class = "text-danger"), 
            " Click-outside-to-close overlay"
          ),
          tags$div(
            icon("mobile-screen", class = "text-secondary"), 
            " Responsive mobile design"
          )
        )
      )
    ),
    
    # Right column - Dashboard
    card(
      class = "feature-card",
      card_header(
        class = "bg-success text-white",
        icon("chart-line"), " Live Dashboard"
      ),
      card_body(
        plotOutput("sample_plot", height = "280px")
      )
    )
  ),
  
  # Statistics cards
  layout_columns(
    col_widths = c(4, 4, 4),
    fillable = FALSE,
    
    value_box(
      title = "Active Users",
      value = "1,234",
      showcase = icon("users"),
      theme = "primary",
      p("↑ 12% from last month", class = "text-muted small")
    ),
    value_box(
      title = "Total Revenue",
      value = "$45.6K",
      showcase = icon("dollar-sign"),
      theme = "success",
      p("↑ 8% from last month", class = "text-muted small")
    ),
    value_box(
      title = "Engagement Rate",
      value = "87%",
      showcase = icon("chart-line"),
      theme = "info",
      p("↑ 5% from last month", class = "text-muted small")
    )
  ),

  # Floating chat module
  floating_chat_ui(
    id = "demo_chat",
    title = "AI Assistant",
    trigger_position = "bottom-right",
    trigger_icon = "robot",
    panel_width = 450,
    panel_height = 650,
    theme = "light",
    enable_minimize = TRUE,
    enable_maximize = TRUE,
    header_actions = actionButton(
      "clear_demo_chat",
      icon("trash-can"),
      class = "btn btn-sm btn-ghost",
      title = "Clear chat history"
    ),
    chat_ui_fun = shinychat::chat_mod_ui
  )
)

# Demo server
server <- function(input, output, session) {
  # Enhanced sample plot with better styling
  output$sample_plot <- renderPlot({
    set.seed(42)
    x <- seq(0, 10, length.out = 100)
    y1 <- sin(x) * 2 + rnorm(100, 0, 0.15)
    y2 <- cos(x) * 1.5 + rnorm(100, 0, 0.15)
    
    par(bg = "#f8f9fa", mar = c(4, 4, 2, 1))
    plot(
      x, y1,
      type = "l",
      col = "#667eea",
      lwd = 3,
      ylim = c(-4, 4),
      main = "Performance Metrics Over Time",
      xlab = "Time Period",
      ylab = "Metric Value",
      family = "sans",
      las = 1
    )
    lines(x, y2, col = "#764ba2", lwd = 3)
    grid(col = "white", lwd = 1.5)
    legend(
      "topright",
      legend = c("Metric A", "Metric B"),
      col = c("#667eea", "#764ba2"),
      lwd = 3,
      bty = "n",
      cex = 0.9
    )
  }, bg = "transparent")

  # In production, use:
  chat <- floating_chat_server(
    id = "demo_chat",
    chat_server_fun = shinychat::chat_mod_server,
    client = ellmer::chat_github(
      system_prompt = "You are a helpful assistant for this demo app."
    )
  )

  # Clear chat handler - reset the chat client
  observeEvent(input$clear_demo_chat, {
    chat$clear()
    showNotification("Chat cleared and client reset!", type = "message", duration = 2)
  })
}

shiny::runApp(shinyApp(ui, server), port = 1234)
