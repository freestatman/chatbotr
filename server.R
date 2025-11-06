library(shiny)

# Source all modules
source("modules/chat_module.R")
source("modules/data_upload_module.R")
source("modules/code_exec_module.R")
source("modules/viz_module.R")
source("modules/utils_module.R")

server <- function(input, output, session) {
  # Initialize data upload module
  dataset <- data_upload_module_server("data_upload")
  
  # Initialize chat module with dataset
  chat_history <- chat_module_server("chat", dataset = dataset)
  
  # Initialize visualization module with chat history
  viz_module_server("viz", chat_history = chat_history)
  
  # Initialize code execution module with dataset
  code_exec_module_server("code_exec", dataset = dataset)
  
  # Optional: Add session cleanup
  session$onSessionEnded(function() {
    # Clean up any resources if needed
    message("Session ended")
  })
}
