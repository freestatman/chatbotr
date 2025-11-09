# Utilities Module
# Utility functions and wrappers for package integration

library(shiny)

#' Get Dataset Information
#' 
#' @param data Data frame
#' @return List containing dataset metadata
get_dataset_info <- function(data) {
  if (!is.data.frame(data)) {
    stop("Input must be a data frame")
  }
  
  info <- list(
    rows = nrow(data),
    columns = names(data),
    n_columns = ncol(data),
    column_types = sapply(data, class),
    numeric_columns = names(data)[sapply(data, is.numeric)],
    character_columns = names(data)[sapply(data, is.character)],
    factor_columns = names(data)[sapply(data, is.factor)],
    missing_values = colSums(is.na(data)),
    total_missing = sum(is.na(data))
  )
  
  return(info)
}

#' Format Number with Commas
#' 
#' @param x Numeric value or vector
#' @param digits Number of decimal places
#' @return Formatted string
format_number <- function(x, digits = 2) {
  format(round(x, digits), big.mark = ",", scientific = FALSE, trim = TRUE)
}

#' Safe Column Access
#' 
#' @param data Data frame
#' @param column Column name
#' @return Column data or NULL if not found
safe_column <- function(data, column) {
  if (column %in% names(data)) {
    return(data[[column]])
  } else {
    warning(paste("Column", column, "not found in dataset"))
    return(NULL)
  }
}

#' Detect Column Type
#' 
#' @param x Vector
#' @return Character string describing the type
detect_column_type <- function(x) {
  if (is.numeric(x)) {
    if (all(x == floor(x), na.rm = TRUE)) {
      return("integer")
    } else {
      return("numeric")
    }
  } else if (is.character(x)) {
    return("character")
  } else if (is.factor(x)) {
    return("factor")
  } else if (is.logical(x)) {
    return("logical")
  } else if (inherits(x, "Date")) {
    return("date")
  } else if (inherits(x, "POSIXt")) {
    return("datetime")
  } else {
    return("other")
  }
}

#' Generate Summary Statistics
#' 
#' @param data Data frame
#' @return Data frame with summary statistics
generate_summary_stats <- function(data) {
  numeric_cols <- sapply(data, is.numeric)
  
  if (sum(numeric_cols) == 0) {
    return(data.frame(Message = "No numeric columns found"))
  }
  
  numeric_data <- data[, numeric_cols, drop = FALSE]
  
  stats <- data.frame(
    Column = names(numeric_data),
    Mean = sapply(numeric_data, mean, na.rm = TRUE),
    Median = sapply(numeric_data, median, na.rm = TRUE),
    SD = sapply(numeric_data, sd, na.rm = TRUE),
    Min = sapply(numeric_data, min, na.rm = TRUE),
    Max = sapply(numeric_data, max, na.rm = TRUE),
    Missing = sapply(numeric_data, function(x) sum(is.na(x))),
    row.names = NULL
  )
  
  return(stats)
}

#' Clean Column Names
#' 
#' @param names Character vector of column names
#' @return Character vector with cleaned names
clean_column_names <- function(names) {
  # Remove special characters, replace spaces with underscores
  names <- gsub("[^A-Za-z0-9_]", "_", names)
  names <- gsub("_{2,}", "_", names)  # Replace multiple underscores with single
  names <- gsub("^_|_$", "", names)   # Remove leading/trailing underscores
  names <- tolower(names)
  
  # Make sure names are unique
  make.unique(names, sep = "_")
}

#' Convert to Safe Data Frame
#' 
#' @param data Input data (data.frame, tibble, data.table, etc.)
#' @return Standard data frame
to_data_frame <- function(data) {
  # Convert various data structures to standard data.frame
  as.data.frame(data, stringsAsFactors = FALSE)
}

#' Check Package Availability
#' 
#' @param pkg Package name
#' @param install_prompt Whether to show installation prompt
#' @return Logical indicating if package is available
check_package <- function(pkg, install_prompt = FALSE) {
  available <- requireNamespace(pkg, quietly = TRUE)
  
  if (!available && install_prompt) {
    message(paste("Package", pkg, "is not installed."))
    message(paste("Install it with: install.packages('", pkg, "')", sep = ""))
  }
  
  return(available)
}

#' Format Time Difference
#' 
#' @param start_time Start time (POSIXct)
#' @param end_time End time (POSIXct)
#' @return Formatted string
format_time_diff <- function(start_time, end_time = Sys.time()) {
  diff <- difftime(end_time, start_time, units = "auto")
  paste(round(diff, 2), attr(diff, "units"))
}

#' Truncate String
#' 
#' @param x Character vector
#' @param max_length Maximum length
#' @param suffix Suffix to add when truncated
#' @return Truncated string
truncate_string <- function(x, max_length = 50, suffix = "...") {
  ifelse(nchar(x) > max_length, 
         paste0(substr(x, 1, max_length - nchar(suffix)), suffix),
         x)
}
