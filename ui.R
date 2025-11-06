library(shiny)
library(bslib)

# Source all modules
source("modules/chat_module.R")
source("modules/data_upload_module.R")
source("modules/code_exec_module.R")
source("modules/viz_module.R")
source("modules/utils_module.R")

ui <- page_navbar(
  title = "R Chatbot",
  theme = bs_theme(
    bootswatch = "flatly",
    primary = "#007bff"
  ),
  
  # Add custom CSS
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  
  # Main chat tab
  nav_panel(
    title = "Chat",
    layout_sidebar(
      sidebar = sidebar(
        title = "Dataset Upload",
        data_upload_module_ui("data_upload"),
        width = 350
      ),
      card(
        card_header("Chat Interface"),
        chat_module_ui("chat")
      )
    )
  ),
  
  # Visualization tab
  nav_panel(
    title = "Visualizations",
    card(
      card_header("Data Visualizations"),
      viz_module_ui("viz")
    )
  ),
  
  # Code execution tab
  nav_panel(
    title = "Code Sandbox",
    card(
      card_header("R Code Execution"),
      code_exec_module_ui("code_exec")
    )
  ),
  
  # About tab
  nav_panel(
    title = "About",
    card(
      card_header("About R Chatbot"),
      markdown("
## R Chatbot

A modern R Shiny chatbot that can answer questions using local files and datasets.

### Features

- **Interactive Chat Interface**: Ask questions about your data in natural language
- **Dataset Upload**: Support for CSV and SAS7BDAT files
- **Code Generation**: Automatically generates R code from your queries
- **Safe Execution**: Runs code in a sandboxed environment
- **Visualizations**: Display tables, plots, and interactive graphics
- **Multiple Analysis Tools**: Summary statistics, data exploration, and more

### How to Use

1. Upload a dataset (CSV or SAS7BDAT) using the sidebar
2. Ask questions in the chat interface
3. View generated code and results
4. Explore visualizations in the Visualizations tab
5. Write custom R code in the Code Sandbox tab

### Example Questions

- \"Show me the first few rows\"
- \"Summarize the data\"
- \"What are the column names?\"
- \"How many rows are there?\"
- \"Calculate the mean of all numeric columns\"

### Required Packages

- shiny, bslib, tidyverse, plotly, ggplot2, echarts4r, gt
- Optional: ellmer, ragnar, shinychat, mcptools, mirai, glue, haven
      ")
    )
  )
)
