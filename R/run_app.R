#' Run the Chatbot Shiny Application
#'
#' @description
#' Runs the Shiny application located in the inst/ directory of this package.
#'
#' @param ... Additional arguments passed to \code{\link[shiny]{runApp}}
#' @param launch.browser Logical. If TRUE, the system's default web browser will be
#'   launched automatically after the app is started. Defaults to TRUE.
#' @param port The TCP port that the application should listen on. If NULL (the default),
#'   a random port will be chosen.
#' @param host The IPv4 address that the application should listen on. Defaults to
#'   the \code{shiny.host} option, if set, or "127.0.0.1" if not.
#'
#' @return No return value. This function is called for its side effect of running
#'   the Shiny application.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Run the app
#' run_app()
#'
#' # Run on a specific port
#' run_app(port = 3838)
#'
#' # Run without opening browser
#' run_app(launch.browser = FALSE)
#' }
run_app <- function(..., launch.browser = TRUE, port = NULL, host = NULL) {
  # Get the app directory path
  app_dir <- system.file("app.R", package = "chatbotr", mustWork = FALSE)
  
  if (app_dir == "") {
    # If package is not installed, try to find the inst directory in development mode
    app_dir <- system.file("inst", "app.R", package = "chatbotr", mustWork = FALSE)
    
    if (app_dir == "") {
      # Fall back to looking for inst/app.R relative to current location
      possible_paths <- c(
        file.path("inst", "app.R"),
        file.path("..", "inst", "app.R"),
        "app.R"
      )
      
      for (path in possible_paths) {
        if (file.exists(path)) {
          app_dir <- dirname(path)
          break
        }
      }
      
      if (!file.exists(file.path(app_dir, "app.R"))) {
        stop("Could not find app.R. Please ensure the package is properly installed or you're in the package directory.")
      }
    } else {
      app_dir <- dirname(app_dir)
    }
  } else {
    app_dir <- dirname(app_dir)
  }
  
  message("Launching app from: ", app_dir)
  
  # Run the app
  shiny::runApp(
    appDir = app_dir,
    launch.browser = launch.browser,
    port = port,
    host = host,
    ...
  )
}
