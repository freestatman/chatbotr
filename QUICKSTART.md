# R Chatbot - Quick Start Guide

## Installation

1. **Install R packages:**

   Run the installation script to install all required dependencies:
   
   ```r
   source("dev/install.R")
   ```

   Or install packages manually:
   
   ```r
   install.packages(c("shiny", "bslib", "dplyr", "tidyr", "readr", 
                      "ggplot2", "plotly", "haven"))
   ```

2. **Launch the application:**

   ```r
   # Using the launcher
   source("app.R")
   
   # Or directly
   shiny::runApp()
   ```

## Usage

### Upload a Dataset

1. Click "Browse" in the sidebar
2. Select a CSV or SAS7BDAT file
3. The dataset will be loaded and previewed

### Chat with Your Data

Try these example questions:

- "Show me the first few rows"
- "Summarize the data"
- "What are the column names?"
- "How many rows are there?"
- "Calculate the mean of all numeric columns"
- "Show missing values"

### Code Sandbox

1. Navigate to the "Code Sandbox" tab
2. Write custom R code
3. Click "Execute Code" to run it safely
4. View results in the output panel

### Visualizations

View generated visualizations in the "Visualizations" tab:
- Static plots
- Data tables
- Interactive plots (with plotly)

## Project Structure

```
/r_bot/
├── ui.R                      # Shiny UI definition
├── server.R                  # Shiny server logic
├── app.R                     # Quick launcher
├── .gitignore                # Git ignore rules
├── modules/
│   ├── chat_module.R         # Chat interface
│   ├── data_upload_module.R  # File upload
│   ├── code_exec_module.R    # Code execution
│   ├── viz_module.R          # Visualizations
│   └── utils_module.R        # Utilities
├── www/
│   └── custom.css            # Custom styles
├── data/
│   └── sample.csv            # Example dataset
└── dev/
    ├── install.R             # Installation script
    └── rag.R                 # RAG utilities (placeholder)
```

## Features

- **Interactive Chat**: Natural language interface for data analysis
- **Dataset Support**: CSV and SAS7BDAT file formats
- **Code Generation**: Automatic R code generation from queries
- **Safe Execution**: Sandboxed code execution environment
- **Visualizations**: Multiple plot types and interactive graphics
- **Modern UI**: Built with bslib and Bootstrap themes

## Troubleshooting

### Package Installation Issues

If package installation fails:

```r
# Update installed packages
update.packages(ask = FALSE)

# Install from CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org/"))
install.packages("package_name")
```

### App Won't Start

Check that all required packages are installed:

```r
required <- c("shiny", "bslib")
installed <- sapply(required, requireNamespace, quietly = TRUE)
print(data.frame(Package = required, Installed = installed))
```

### File Upload Issues

- Ensure file is in CSV or SAS7BDAT format
- Check file size (large files may take time to load)
- Verify file encoding (UTF-8 recommended)

## Next Steps

1. Customize the chat responses in `modules/chat_module.R`
2. Add more visualization types in `modules/viz_module.R`
3. Integrate AI/LLM capabilities using ellmer or other packages
4. Add RAG (Retrieval Augmented Generation) features
5. Deploy to Shiny Server or shinyapps.io

## Resources

- [Shiny Documentation](https://shiny.rstudio.com/)
- [bslib Documentation](https://rstudio.github.io/bslib/)
- [Plotly for R](https://plotly.com/r/)

## License

MIT License
