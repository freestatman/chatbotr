# Visualization Module
# Handles visualization of tables and plots in the chat interface

library(shiny)

#' Visualization Module UI
#' 
#' @param id Module namespace ID
#' @return Shiny UI elements
viz_module_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    h4("Visualizations"),
    tabsetPanel(
      tabPanel("Plot", 
        plotOutput(ns("plot_output"), height = "400px")
      ),
      tabPanel("Table",
        tableOutput(ns("table_output"))
      ),
      tabPanel("Interactive Plot",
        uiOutput(ns("interactive_plot"))
      )
    )
  )
}

#' Visualization Module Server
#' 
#' @param id Module namespace ID
#' @param chat_history Reactive containing chat history
#' @return NULL
viz_module_server <- function(id, chat_history) {
  moduleServer(id, function(input, output, session) {
    
    # Store current visualization data
    viz_data <- reactiveVal(NULL)
    
    # Monitor chat history for visualization requests
    observe({
      messages <- chat_history()
      
      if (length(messages) > 0) {
        last_msg <- messages[[length(messages)]]
        
        # Check if the last message contains visualization data
        if (!is.null(last_msg$viz_data)) {
          viz_data(last_msg$viz_data)
        }
      }
    })
    
    # Render basic plot
    output$plot_output <- renderPlot({
      data <- viz_data()
      
      if (is.null(data)) {
        plot.new()
        text(0.5, 0.5, "No visualization data available", cex = 1.5)
        return()
      }
      
      # Generate appropriate plot based on data type
      if (is.data.frame(data)) {
        # Simple scatter plot or histogram
        numeric_cols <- sapply(data, is.numeric)
        
        if (sum(numeric_cols) >= 2) {
          # Scatter plot
          cols <- names(data)[numeric_cols][1:2]
          plot(data[[cols[1]]], data[[cols[2]]],
               xlab = cols[1], ylab = cols[2],
               main = paste(cols[1], "vs", cols[2]),
               pch = 19, col = rgb(0, 0, 1, 0.5))
        } else if (sum(numeric_cols) == 1) {
          # Histogram
          col <- names(data)[numeric_cols][1]
          hist(data[[col]], 
               main = paste("Distribution of", col),
               xlab = col,
               col = "steelblue",
               border = "white")
        }
      }
    })
    
    # Render table
    output$table_output <- renderTable({
      data <- viz_data()
      
      if (is.null(data)) {
        return(data.frame(Message = "No data to display"))
      }
      
      if (is.data.frame(data)) {
        head(data, 20)
      } else {
        data.frame(Value = as.character(data))
      }
    }, striped = TRUE, hover = TRUE, bordered = TRUE)
    
    # Render interactive plot (placeholder for plotly/echarts4r)
    output$interactive_plot <- renderUI({
      data <- viz_data()
      
      if (is.null(data)) {
        return(p("No interactive visualization available", 
                style = "text-align: center; color: #999; padding: 50px;"))
      }
      
      # Check if plotly is available
      if (requireNamespace("plotly", quietly = TRUE)) {
        renderPlotly({
          if (is.data.frame(data)) {
            numeric_cols <- sapply(data, is.numeric)
            if (sum(numeric_cols) >= 2) {
              cols <- names(data)[numeric_cols][1:2]
              plotly::plot_ly(data, x = ~get(cols[1]), y = ~get(cols[2]), 
                            type = 'scatter', mode = 'markers',
                            marker = list(size = 10, opacity = 0.6))
            }
          }
        })
      } else {
        p("Install 'plotly' package for interactive visualizations: install.packages('plotly')",
          style = "text-align: center; color: #666; padding: 50px;")
      }
    })
  })
}

#' Create a basic plot from data
#' 
#' @param data Data frame or vector
#' @param type Type of plot ("scatter", "histogram", "bar", etc.)
#' @return Plot object
create_plot <- function(data, type = "auto") {
  
  if (!is.data.frame(data) && !is.vector(data)) {
    stop("Data must be a data frame or vector")
  }
  
  if (is.vector(data)) {
    # Create histogram for vector
    hist(data, main = "Distribution", xlab = "Value", col = "steelblue")
    return(invisible(NULL))
  }
  
  # For data frames, auto-detect plot type
  numeric_cols <- sapply(data, is.numeric)
  
  if (type == "auto") {
    if (sum(numeric_cols) >= 2) {
      type <- "scatter"
    } else if (sum(numeric_cols) == 1) {
      type <- "histogram"
    } else {
      type <- "bar"
    }
  }
  
  if (type == "scatter" && sum(numeric_cols) >= 2) {
    cols <- names(data)[numeric_cols][1:2]
    plot(data[[cols[1]]], data[[cols[2]]],
         xlab = cols[1], ylab = cols[2],
         main = paste(cols[1], "vs", cols[2]),
         pch = 19, col = rgb(0, 0, 1, 0.5))
  } else if (type == "histogram" && sum(numeric_cols) >= 1) {
    col <- names(data)[numeric_cols][1]
    hist(data[[col]], 
         main = paste("Distribution of", col),
         xlab = col,
         col = "steelblue",
         border = "white")
  }
  
  invisible(NULL)
}
