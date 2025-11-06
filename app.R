# Run R Chatbot Application
# Quick launcher script

cat("Starting R Chatbot...\n\n")

# Check if required packages are installed
required_packages <- c("shiny", "bslib")

missing_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]

if (length(missing_packages) > 0) {
  cat("Missing required packages:", paste(missing_packages, collapse = ", "), "\n")
  cat("Please run dev/install.R first to install dependencies.\n")
  cat("  source('dev/install.R')\n\n")
  stop("Missing required packages")
}

# Run the Shiny app
cat("Launching app...\n")
shiny::runApp(launch.browser = TRUE)
