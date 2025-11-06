# RChatbot

A modern R Shiny chatbot that can answer questions using local files and datasets (CSV, SAS7BDAT). For dataset-related questions, it generates and executes R code in a sandbox, displaying results in the chat UI.

## Features

- **Chatbot interface** using Shiny and shinychat
- **Upload and manage datasets** (CSV, SAS7BDAT)
- **Generate and execute R code** safely in a sandboxed environment
- **Display tables and plots** interactively in the chat
- **Uses R packages:**
  ellmer, ragnar, shinychat, mcptools, bslib, shiny, mirai, tidyverse, glue, plotly, ggplot2, echarts4r, gt

## Project Structure

```
/RChatbot/
├── ui.R                      # Shiny UI definition
├── server.R                  # Shiny server logic
├── modules/
│   ├── chat_module.R         # Chatbot logic and UI module
│   ├── data_upload_module.R  # File upload and dataset management module
│   ├── code_exec_module.R    # Code generation and sandboxed execution module
│   ├── viz_module.R          # Visualization (plots, tables) module
│   └── utils_module.R        # Utility functions, package wrappers
├── www/
│   └── custom.css            # Custom styles (optional)
├── data/
│   └── sample.csv            # Example dataset (optional)
├── README.md                 # Project documentation
├── .codecompanion.workspace.json # Workspace configuration
```

## Getting Started

1. **Install required R packages:**
   ```r
   install.packages(c(
     "shiny", "bslib", "tidyverse", "glue", "plotly", "ggplot2", "echarts4r", "gt"
   ))
   # For packages not on CRAN, use remotes::install_github() as needed
   ```

2. **Run the app:**
   ```r
   shiny::runApp()
   ```

3. **Upload a dataset** (CSV or SAS7BDAT) via the sidebar.

4. **Ask questions** in the chat interface. For dataset-related queries, the chatbot will generate and execute R code, displaying results in the chat.

## Workspace Configuration

See `.codecompanion.workspace.json` for workspace groups and context.

## License

MIT License (or specify your own)
