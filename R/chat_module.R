# Chat Module
# Handles the chatbot interface and logic

library(shiny)
library(bslib)

#' Chat Module UI
#' 
#' @param id Module namespace ID
#' @return Shiny UI elements
chat_module_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    h3("Chat Interface"),
    div(
      id = ns("chat_container"),
      style = "height: 500px; overflow-y: auto; border: 1px solid #ddd; padding: 10px; margin-bottom: 10px; background-color: #f9f9f9;",
      uiOutput(ns("chat_history"))
    ),
    fluidRow(
      column(10,
        textInput(ns("user_message"), 
                  label = NULL, 
                  placeholder = "Type your message here...",
                  width = "100%")
      ),
      column(2,
        actionButton(ns("send_btn"), 
                     "Send", 
                     class = "btn-primary",
                     width = "100%")
      )
    )
  )
}

#' Chat Module Server
#' 
#' @param id Module namespace ID
#' @param dataset Reactive containing the uploaded dataset
#' @return Reactive containing chat history
chat_module_server <- function(id, dataset) {
  moduleServer(id, function(input, output, session) {
    
    # Store chat history
    chat_messages <- reactiveVal(list())
    
    # Add message to chat
    add_message <- function(role, content, type = "text") {
      messages <- chat_messages()
      messages[[length(messages) + 1]] <- list(
        role = role,
        content = content,
        type = type,
        timestamp = Sys.time()
      )
      chat_messages(messages)
    }
    
    # Handle send button click
    observeEvent(input$send_btn, {
      req(input$user_message)
      
      user_msg <- trimws(input$user_message)
      if (nchar(user_msg) == 0) return()
      
      # Add user message
      add_message("user", user_msg)
      
      # Clear input
      updateTextInput(session, "user_message", value = "")
      
      # Process message and generate response
      tryCatch({
        # Check if dataset is available
        data <- dataset()
        
        if (is.null(data)) {
          response <- "Please upload a dataset first to ask data-related questions."
          add_message("assistant", response)
        } else {
          # Generate response based on user query
          response <- process_query(user_msg, data)
          add_message("assistant", response$text)
          
          # If code was generated, add it to chat
          if (!is.null(response$code)) {
            add_message("assistant", response$code, type = "code")
          }
          
          # If result is available, add it
          if (!is.null(response$result)) {
            add_message("assistant", response$result, type = "result")
          }
        }
      }, error = function(e) {
        add_message("assistant", paste("Error:", e$message))
      })
    })
    
    # Process user query
    process_query <- function(query, data) {
      result <- list(text = "", code = NULL, result = NULL)
      
      # Simple pattern matching for demo
      query_lower <- tolower(query)
      
      if (grepl("hello|hi|hey", query_lower)) {
        result$text <- "Hello! I'm your R chatbot assistant. I can help you analyze your dataset. Try asking questions like 'show me the first few rows' or 'summarize the data'."
      } else if (grepl("first|head|preview", query_lower)) {
        result$text <- "Here are the first few rows of your dataset:"
        result$code <- "head(dataset, 10)"
        result$result <- capture.output(print(head(data, 10)))
      } else if (grepl("summary|summarize|describe", query_lower)) {
        result$text <- "Here's a summary of your dataset:"
        result$code <- "summary(dataset)"
        result$result <- capture.output(print(summary(data)))
      } else if (grepl("column|variable|name", query_lower)) {
        result$text <- paste("Your dataset has", ncol(data), "columns:", paste(names(data), collapse = ", "))
      } else if (grepl("row|observation|record", query_lower)) {
        result$text <- paste("Your dataset has", nrow(data), "rows.")
      } else {
        result$text <- "I can help you analyze your dataset. Try asking me to show the first few rows, summarize the data, or tell you about columns and rows."
      }
      
      return(result)
    }
    
    # Render chat history
    output$chat_history <- renderUI({
      messages <- chat_messages()
      
      if (length(messages) == 0) {
        return(p("No messages yet. Start chatting!", style = "color: #999;"))
      }
      
      message_divs <- lapply(messages, function(msg) {
        if (msg$role == "user") {
          div(
            class = "chat-message user-message",
            style = "background-color: #007bff; color: white; padding: 10px; margin: 5px 0; border-radius: 10px; max-width: 80%; margin-left: auto; text-align: right;",
            strong("You: "),
            msg$content
          )
        } else {
          content_div <- if (msg$type == "code") {
            pre(
              style = "background-color: #f4f4f4; padding: 10px; border-radius: 5px; overflow-x: auto;",
              code(msg$content)
            )
          } else if (msg$type == "result") {
            pre(
              style = "background-color: #e8f4f8; padding: 10px; border-radius: 5px; overflow-x: auto; font-size: 12px;",
              paste(msg$content, collapse = "\n")
            )
          } else {
            p(msg$content, style = "margin: 0;")
          }
          
          div(
            class = "chat-message assistant-message",
            style = "background-color: #f1f1f1; padding: 10px; margin: 5px 0; border-radius: 10px; max-width: 80%;",
            strong("Assistant: "),
            content_div
          )
        }
      })
      
      tagList(message_divs)
    })
    
    # Return chat history for other modules
    return(chat_messages)
  })
}
