# Data Upload Module
# Handles file upload and dataset management

library(shiny)

#' Data Upload Module UI
#' 
#' @param id Module namespace ID
#' @return Shiny UI elements
data_upload_module_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    fileInput(
      ns("file"),
      "Choose File",
      accept = c(
        "text/csv",
        "text/comma-separated-values,text/plain",
        ".csv",
        ".sas7bdat"
      )
    ),
    uiOutput(ns("file_info")),
    hr(),
    h5("Dataset Preview"),
    tableOutput(ns("preview"))
  )
}

#' Data Upload Module Server
#' 
#' @param id Module namespace ID
#' @return Reactive containing the uploaded dataset
data_upload_module_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Store the uploaded dataset
    dataset <- reactiveVal(NULL)
    
    # Handle file upload
    observeEvent(input$file, {
      req(input$file)
      
      tryCatch({
        file_path <- input$file$datapath
        file_ext <- tools::file_ext(input$file$name)
        
        data <- if (tolower(file_ext) == "csv") {
          read.csv(file_path, stringsAsFactors = FALSE)
        } else if (tolower(file_ext) == "sas7bdat") {
          # Check if haven package is available
          if (requireNamespace("haven", quietly = TRUE)) {
            haven::read_sas(file_path)
          } else {
            stop("The 'haven' package is required to read SAS files. Please install it with: install.packages('haven')")
          }
        } else {
          stop("Unsupported file format. Please upload a CSV or SAS7BDAT file.")
        }
        
        # Convert to data frame if needed
        data <- as.data.frame(data)
        
        # Store the dataset
        dataset(data)
        
        showNotification(
          paste("Successfully loaded", input$file$name),
          type = "message",
          duration = 3
        )
        
      }, error = function(e) {
        showNotification(
          paste("Error loading file:", e$message),
          type = "error",
          duration = 5
        )
        dataset(NULL)
      })
    })
    
    # Display file information
    output$file_info <- renderUI({
      req(dataset())
      
      data <- dataset()
      
      tagList(
        p(strong("File: "), input$file$name),
        p(strong("Rows: "), nrow(data)),
        p(strong("Columns: "), ncol(data)),
        p(strong("Column Names: "), paste(names(data), collapse = ", "))
      )
    })
    
    # Display dataset preview
    output$preview <- renderTable({
      req(dataset())
      
      data <- dataset()
      head(data, 10)
    }, striped = TRUE, hover = TRUE, bordered = TRUE)
    
    # Return the dataset for other modules
    return(dataset)
  })
}
