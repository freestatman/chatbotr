# Installation Script for R Chatbot
# This script installs all required and optional packages

cat("Installing R Chatbot dependencies...\n\n")

# List of required packages from CRAN
cran_packages <- c(
  "shiny",
  "bslib",
  "dplyr",
  "tidyr",
  "readr",
  "ggplot2",
  "plotly",
  "haven"  # For reading SAS files
)

# List of optional packages
optional_packages <- c(
  "echarts4r",
  "gt",
  "glue",
  "DT",
  "tidyverse"
)

# Install CRAN packages
cat("Installing required CRAN packages...\n")
for (pkg in cran_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat(paste("Installing", pkg, "...\n"))
    install.packages(pkg, dependencies = TRUE)
  } else {
    cat(paste(pkg, "is already installed.\n"))
  }
}

cat("\nInstalling optional packages...\n")
for (pkg in optional_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat(paste("Installing", pkg, "...\n"))
    tryCatch({
      install.packages(pkg, dependencies = TRUE)
    }, error = function(e) {
      cat(paste("Could not install", pkg, "- skipping.\n"))
    })
  } else {
    cat(paste(pkg, "is already installed.\n"))
  }
}

# Check for GitHub packages (if remotes is available)
if (!requireNamespace("remotes", quietly = TRUE)) {
  cat("\nInstalling 'remotes' package for GitHub installations...\n")
  install.packages("remotes")
}

# Optional: Install development packages from GitHub
# Uncomment to install these packages:
# github_packages <- list(
#   list(repo = "jcheng5/ellmer", ref = "main"),
#   list(repo = "jcheng5/shinychat", ref = "main")
# )

cat("\n==============================================\n")
cat("Installation complete!\n")
cat("==============================================\n\n")

# Verify installation
cat("Verifying installations...\n")
all_packages <- c(cran_packages, optional_packages)
installed <- sapply(all_packages, requireNamespace, quietly = TRUE)

cat("\nInstalled packages:\n")
print(data.frame(
  Package = all_packages,
  Installed = ifelse(installed, "Yes", "No"),
  stringsAsFactors = FALSE
))

if (all(installed[1:length(cran_packages)])) {
  cat("\nAll required packages installed successfully!\n")
  cat("\nYou can now run the app with:\n")
  cat("  source('app.R')\n")
  cat("  # or\n")
  cat("  shiny::runApp()\n\n")
} else {
  cat("\nSome required packages failed to install.\n")
  cat("Please install them manually.\n\n")
}



