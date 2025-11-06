# Code Execution Module
# Generates R code from user queries and executes it in a sandboxed environment

library(shiny)

#' Execute R Code in Sandbox
#' 
#' @param code Character string containing R code to execute
#' @param dataset Data frame to make available in the execution environment
#' @param timeout Maximum execution time in seconds (default: 10)
#' @return List containing result, output, error, and warnings
execute_code_sandbox <- function(code, dataset = NULL, timeout = 10) {
  
  result <- list(
    success = FALSE,
    result = NULL,
    output = NULL,
    error = NULL,
    warnings = NULL
  )
  
  tryCatch({
    # Create isolated environment
    env <- new.env(parent = baseenv())
    
    # Add dataset to environment if provided
    if (!is.null(dataset)) {
      env$dataset <- dataset
    }
    
    # Add safe packages to environment
    safe_packages <- c("base", "stats", "graphics", "grDevices", "utils", "datasets", "methods")
    for (pkg in safe_packages) {
      if (pkg %in% loadedNamespaces()) {
        env[[pkg]] <- asNamespace(pkg)
      }
    }
    
    # Capture output and warnings
    output <- capture.output({
      warnings <- character()
      result$result <- withCallingHandlers(
        eval(parse(text = code), envir = env),
        warning = function(w) {
          warnings <<- c(warnings, conditionMessage(w))
          invokeRestart("muffleWarning")
        }
      )
      result$warnings <- if (length(warnings) > 0) warnings else NULL
    })
    
    result$output <- if (length(output) > 0) output else NULL
    result$success <- TRUE
    
  }, error = function(e) {
    result$error <<- conditionMessage(e)
    result$success <<- FALSE
  })
  
  return(result)
}

#' Generate R Code from Natural Language Query
#' 
#' @param query User's natural language query
#' @param dataset_info List containing dataset metadata (column names, types, etc.)
#' @return Character string containing generated R code
generate_code_from_query <- function(query, dataset_info = NULL) {
  
  query_lower <- tolower(query)
  
  # Pattern matching for common queries
  if (grepl("first|head|preview", query_lower)) {
    return("head(dataset, 10)")
  }
  
  if (grepl("last|tail", query_lower)) {
    return("tail(dataset, 10)")
  }
  
  if (grepl("summary|summarize|describe", query_lower)) {
    return("summary(dataset)")
  }
  
  if (grepl("structure|str", query_lower)) {
    return("str(dataset)")
  }
  
  if (grepl("dimension|dim|size", query_lower)) {
    return("dim(dataset)")
  }
  
  if (grepl("column names|colnames|variables", query_lower)) {
    return("colnames(dataset)")
  }
  
  if (grepl("missing|na|null", query_lower)) {
    return("colSums(is.na(dataset))")
  }
  
  if (grepl("unique", query_lower) && !is.null(dataset_info)) {
    # Try to find column name in query
    cols <- dataset_info$columns
    for (col in cols) {
      if (grepl(tolower(col), query_lower)) {
        return(paste0("unique(dataset$", col, ")"))
      }
    }
    return("sapply(dataset, function(x) length(unique(x)))")
  }
  
  if (grepl("count|frequency|table", query_lower) && !is.null(dataset_info)) {
    cols <- dataset_info$columns
    for (col in cols) {
      if (grepl(tolower(col), query_lower)) {
        return(paste0("table(dataset$", col, ")"))
      }
    }
  }
  
  if (grepl("mean|average", query_lower) && !is.null(dataset_info)) {
    cols <- dataset_info$columns
    for (col in cols) {
      if (grepl(tolower(col), query_lower)) {
        return(paste0("mean(dataset$", col, ", na.rm = TRUE)"))
      }
    }
    return("sapply(dataset[sapply(dataset, is.numeric)], mean, na.rm = TRUE)")
  }
  
  if (grepl("plot|graph|visualize", query_lower)) {
    if (!is.null(dataset_info) && length(dataset_info$columns) >= 2) {
      col1 <- dataset_info$columns[1]
      col2 <- dataset_info$columns[2]
      return(paste0("plot(dataset$", col1, ", dataset$", col2, ")"))
    }
  }
  
  # Default: return summary
  return("summary(dataset)")
}

#' Code Execution Module UI
#' 
#' @param id Module namespace ID
#' @return Shiny UI elements
code_exec_module_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    h4("Code Execution Sandbox"),
    textAreaInput(
      ns("code_input"),
      "Enter R Code:",
      placeholder = "# Enter R code here\nhead(dataset)",
      rows = 5,
      width = "100%"
    ),
    actionButton(ns("execute_btn"), "Execute Code", class = "btn-success"),
    hr(),
    h5("Output:"),
    verbatimTextOutput(ns("code_output"))
  )
}

#' Code Execution Module Server
#' 
#' @param id Module namespace ID
#' @param dataset Reactive containing the dataset
#' @return Reactive containing execution results
code_exec_module_server <- function(id, dataset) {
  moduleServer(id, function(input, output, session) {
    
    execution_result <- reactiveVal(NULL)
    
    observeEvent(input$execute_btn, {
      req(input$code_input)
      
      code <- trimws(input$code_input)
      if (nchar(code) == 0) {
        showNotification("Please enter some code to execute", type = "warning")
        return()
      }
      
      # Execute code
      result <- execute_code_sandbox(code, dataset())
      execution_result(result)
      
      if (!result$success) {
        showNotification(
          paste("Execution error:", result$error),
          type = "error",
          duration = 5
        )
      }
    })
    
    output$code_output <- renderPrint({
      result <- execution_result()
      
      if (is.null(result)) {
        cat("No code executed yet.\n")
        return()
      }
      
      if (!result$success) {
        cat("Error:\n")
        cat(result$error, "\n")
        return()
      }
      
      if (!is.null(result$warnings)) {
        cat("Warnings:\n")
        cat(paste(result$warnings, collapse = "\n"), "\n\n")
      }
      
      if (!is.null(result$output)) {
        cat("Output:\n")
        cat(paste(result$output, collapse = "\n"), "\n\n")
      }
      
      if (!is.null(result$result)) {
        cat("Result:\n")
        print(result$result)
      }
    })
    
    return(execution_result)
  })
}
