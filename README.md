# chatbotr

> Shiny Chatbot Application with Offcanvas Interface

An R package that provides an interactive chatbot interface using Shiny with an offcanvas (slide-out) panel design. Integrates with `shinychat` and `ellmer` for AI-powered conversations.

## Installation

You can install the development version from GitHub:

```r
# install.packages("devtools")
devtools::install_github("freestatman/chatbotr")
```

Or install locally:

```r
devtools::install()
```

## Quick Start

### Running the Application

```r
library(chatbotr)

# Launch the chatbot app
run_app()

# Or with custom options
run_app(port = 3838, launch.browser = FALSE)
```

### Using the Modules

#### Offcanvas Chat (Edge Panel)

You can use the offcanvas chat modules in your own Shiny applications:

```r
library(shiny)
library(bslib)
library(chatbotr)

ui <- page_fluid(
  theme = bs_theme(version = 5),
  h3("My App with Chatbot"),
  
  # Add the offcanvas chat interface
  offcanvas_chat_ui(
    id = "assistant",
    title = "AI Assistant",
    placement = "end",
    width = 420,
    open_label = "Open Chat",
    open_class = "btn btn-outline-primary",
    open_icon = "comments",
    chat_ui_fun = shinychat::chat_mod_ui
  )
)

server <- function(input, output, session) {
  github <- ellmer::chat_github()
  
  offcanvas_chat_server(
    id = "assistant",
    chat_server_fun = shinychat::chat_mod_server,
    client = github
  )
}

shinyApp(ui, server)
```

#### Floating Chat (Modern Chatbot Style)

For a modern floating chatbot experience:

```r
library(shiny)
library(bslib)
library(chatbotr)

ui <- page_fluid(
  theme = bs_theme(version = 5),
  
  # Include floating chat CSS
  tags$head(
    tags$link(rel = "stylesheet", href = "floating_chat.css")
  ),
  
  h3("My App"),
  p("Your main content here..."),
  
  # Add floating chat interface
  floating_chat_ui(
    id = "chat",
    title = "AI Assistant",
    trigger_position = "bottom-right",  # or bottom-left, top-right, top-left
    theme = "light",  # or "dark"
    chat_ui_fun = shinychat::chat_ui
  )
)

server <- function(input, output, session) {
  client <- ellmer::chat_github(
    system_prompt = "You are a helpful assistant."
  )
  
  floating_chat_server(
    id = "chat",
    chat_server_fun = shinychat::chat_server,
    client = client
  )
}

shinyApp(ui, server)
```

**Quick Start Guides:**
- Floating Chat: See `inst/www/FLOATING_CHAT_QUICKSTART.md`
- Full Demo: Run `inst/examples/floating_chat_demo.R`

## Features

### Two Chat Interface Styles

#### 1. Offcanvas Chat (Edge Panel)
- **Edge-Anchored Interface**: Clean slide-out chat panel from screen edges
- **Flexible Placement**: Position the chat panel on any side (left, right, top, bottom)
- **Customizable Appearance**: Configure width, buttons, and behavior
- **Best For**: Side navigation, persistent chat panels, desktop applications

#### 2. Floating Chat (NEW! ✨)
- **Modern Floating Button**: Discreet circular trigger icon (customizable position)
- **Overlay Panel**: Beautiful floating chat window that appears on click
- **shadcn/ui Design**: Modern, clean aesthetic with smooth animations
- **Minimize Support**: Collapsible panel with minimize/expand functionality
- **Theme Support**: Built-in light and dark themes
- **Responsive**: Full-screen on mobile, floating on desktop
- **Best For**: Chatbot interfaces, customer support, AI assistants

### General Features
- **Modular Design**: Easy to integrate into existing Shiny applications
- **AI-Powered**: Works with `shinychat` and `ellmer` for intelligent conversations
- **Fully Customizable**: Extensive configuration options for both modules

## Package Structure

```
chatbotr/
├── DESCRIPTION           # Package metadata
├── NAMESPACE            # Exported functions
├── LICENSE              # MIT License
├── README.md            # This file
├── R/                   # R source code
│   ├── offcanvas_chat_module.R  # Main module functions
│   └── run_app.R        # App launcher
├── inst/                # Installed files
│   ├── app.R           # Example application
│   └── www/            # Web assets
│       └── custom.css  # Custom styles
├── tests/              # Unit tests
│   ├── testthat.R
│   └── testthat/
│       └── test-run_app.R
├── data/               # Example data
└── dev/                # Development scripts
```

## Development

### Setup Development Environment

```r
# Install development dependencies
install.packages(c("devtools", "roxygen2", "testthat"))

# Load the package for development
devtools::load_all()
```

### Running Tests

```r
# Run all tests
devtools::test()

# Or specific test file
testthat::test_file("tests/testthat/test-run_app.R")
```

### Building Documentation

```r
# Generate documentation from roxygen comments
devtools::document()

# Build README
devtools::build_readme()
```

### Installing Package Locally

```r
# Install from source
devtools::install()

# Or build and install
devtools::build()
devtools::install_local("chatbotr_0.1.0.tar.gz")
```

## API Reference

### Offcanvas Chat Module

#### `offcanvas_chat_ui()`

Create the UI for an offcanvas chat interface.

**Parameters:**
- `id` - Namespace ID for the module
- `title` - Title displayed in the offcanvas header
- `placement` - Position: "end", "start", "bottom", or "top"
- `width` - Width in pixels (for side placement)
- `open_label` - Text for the open button
- `open_class` - CSS classes for the open button
- `open_icon` - Icon name for the open button
- `chat_ui_fun` - Function to generate the chat UI
- `chat_ui_args` - List of arguments passed to `chat_ui_fun`
- `header_right` - Optional UI elements for header right side

#### `offcanvas_chat_server()`

Server logic for the offcanvas chat module.

**Parameters:**
- `id` - Namespace ID matching the UI
- `chat_server_fun` - Server function for the chat module
- `...` - Additional arguments passed to `chat_server_fun`

### Floating Chat Module

#### `floating_chat_ui()`

Create a floating chat interface with customizable trigger and overlay panel.

**Parameters:**
- `id` - Namespace ID for the module
- `title` - Title displayed in the chat panel header (default: "Chat Assistant")
- `trigger_position` - Position: "bottom-right", "bottom-left", "top-right", "top-left"
- `trigger_icon` - Icon name for trigger button (default: "comments")
- `trigger_size` - Size of trigger button in pixels (default: 60)
- `panel_width` - Width of chat panel in pixels (default: 400)
- `panel_height` - Height of chat panel in pixels (default: 600)
- `panel_offset` - Offset from viewport edges in pixels (default: 20)
- `theme` - Color theme: "light" or "dark" (default: "light")
- `enable_minimize` - Enable minimize functionality (default: TRUE)
- `chat_ui_fun` - Function to generate the chat UI
- `chat_ui_args` - List of arguments passed to `chat_ui_fun`
- `header_actions` - Optional UI elements for header actions

#### `floating_chat_server()`

Server logic for the floating chat module.

**Parameters:**
- `id` - Namespace ID matching the UI
- `chat_server_fun` - Server function for the chat module
- `...` - Additional arguments passed to `chat_server_fun`

### App Launcher

#### `run_app()`

Launch the chatbot Shiny application.

**Parameters:**
- `...` - Additional arguments passed to `shiny::runApp()`
- `launch.browser` - Logical; open browser automatically (default: `TRUE`)
- `port` - TCP port number (default: random)
- `host` - IPv4 address to listen on (default: "127.0.0.1")

## BYOK (Bring Your Own Key)

The chatbotr package now supports **Bring Your Own Key (BYOK)** functionality, giving you complete control over your AI provider and model selection.

### Supported Providers

- **GitHub Models** - GPT-4o, Llama, Phi-3.5, Mistral
- **OpenAI** - GPT-4, GPT-3.5, o1
- **Anthropic** - Claude 3.5 Sonnet, Claude 3 Opus
- **Google Gemini** - Gemini 1.5 Pro/Flash
- **Azure OpenAI** - Enterprise deployments
- **Ollama** - Local LLM inference

### Quick Example

```r
library(shiny)
library(bslib)
library(chatbotr)

ui <- page_fluid(
  # Settings UI
  api_settings_ui("settings"),
  
  # Chat interface
  floating_chat_ui(
    id = "chat",
    chat_ui_fun = shinychat::chat_mod_ui
  )
)

server <- function(input, output, session) {
  # Configure API settings
  settings <- api_settings_server("settings")
  
  # Initialize chat when configured
  observe({
    req(settings$is_configured())
    floating_chat_server(
      "chat",
      chat_server_fun = shinychat::chat_mod_server,
      client = settings$client()
    )
  })
}

shinyApp(ui, server)
```

### Documentation

For comprehensive BYOK documentation, see:
- [BYOK Guide](inst/www/BYOK_GUIDE.md) - Complete guide with examples
- [Floating Chat Example](inst/examples/byok_floating_chat.R) - Working example
- [Offcanvas Chat Example](inst/examples/byok_offcanvas_chat.R) - Alternative pattern

Run examples:

```r
# Floating chat with BYOK
source(system.file("examples/byok_floating_chat.R", package = "chatbotr"))

# Offcanvas chat with BYOK
source(system.file("examples/byok_offcanvas_chat.R", package = "chatbotr"))
```

## Dependencies

- **shiny** (>= 1.7.0) - Web application framework
- **bslib** (>= 0.5.0) - Bootstrap themes for Shiny
- **shinychat** - Chat interface components
- **ellmer** - AI/LLM client integration

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Resources

- [Shiny Documentation](https://shiny.rstudio.com/)
- [bslib Documentation](https://rstudio.github.io/bslib/)
- [shinychat](https://github.com/posit-dev/shinychat)
- [ellmer](https://github.com/hadley/ellmer)
