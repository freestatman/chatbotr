# chatbotr

> Modern AI Chat Interfaces for Shiny Applications

An R package that provides elegant, customizable chat interfaces for Shiny applications. Features floating chat widgets and offcanvas panels with full BYOK (Bring Your Own Key) support for multiple LLM providers. Integrates seamlessly with `shinychat` and `ellmer`.

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

### Minimal Floating Chat Example

```r
library(shiny)
library(bslib)
library(chatbotr)

ui <- page_fluid(
  theme = bs_theme(version = 5),
  h1("My App"),
  p("Your main content here..."),
  
  # Add floating chat - just 3 lines!
  floating_chat_ui(
    id = "chat",
    welcome_message = "Hi! How can I help you today?"
  )
)

server <- function(input, output, session) {
  # Connect to LLM provider
  floating_chat_server(
    id = "chat",
    client = ellmer::chat_github(model = "gpt-4-mini")  # Free tier via GitHub Models
  )
}

shinyApp(ui, server)
```

### BYOK (Bring Your Own Key) Example

For production apps with user-provided API keys:

```r
library(shiny)
library(bslib)
library(chatbotr)

ui <- page_fluid(
  theme = bs_theme(version = 5),
  
  # Settings modal for API key configuration
  api_settings_ui("settings"),
  
  # Floating chat with settings button
  floating_chat_ui(
    id = "chat",
    header_actions = actionButton("open_settings", icon("gear"))
  )
)

server <- function(input, output, session) {
  # Configure API settings
  settings <- api_settings_server(
    id = "settings",
    default_system_prompt = "You are a helpful assistant."
  )
  
  # Initialize chat when settings are configured
  observe({
    req(settings$is_configured())
    floating_chat_server(
      id = "chat",
      client = settings$client()
    )
  })
}

shinyApp(ui, server)
```

### Running Example Apps

```r
# Minimal floating chat demo
shiny::runApp(system.file("examples/floating_chat_demo.R", package = "chatbotr"))

# BYOK with floating chat
shiny::runApp(system.file("examples/byok_floating_chat.R", package = "chatbotr"))

# Offcanvas (side panel) chat
shiny::runApp(system.file("examples/offcanvas_chat_demo.R", package = "chatbotr"))
```

## Features

### Design Philosophy: Intentional Minimalism

- **Clean Monochromatic Palette**: Black, white, and grays only
- **Subtle Interactions**: Quick 150ms transitions, no flashy effects
- **Typography**: System fonts, medium weights, tight letter-spacing
- **Accessibility**: ARIA labels, keyboard navigation, focus management

### Two Chat Interface Styles

#### 1. Floating Chat
- **Floating Trigger Button**: Circular button in any corner
- **Overlay Panel**: Clean chat window that appears on click
- **Minimize/Maximize**: Full control with panel sizing
- **Suggested Prompts**: Clickable chips for quick input
- **Responsive**: Full-screen on mobile, floating on desktop

#### 2. Offcanvas Chat
- **Edge-Anchored**: Slide-out panel from any screen edge
- **Flexible Placement**: Left, right, top, or bottom
- **Configurable Width**: Set panel size as needed

### BYOK (Bring Your Own Key)
- **Multiple Providers**: GitHub, OpenAI, Anthropic, Google, Azure, Ollama
- **Settings Modal**: User-configurable API key input
- **Connection Testing**: Verify settings before use

## Package Structure

```
chatbotr/
├── DESCRIPTION                      # Package metadata
├── NAMESPACE                        # Exported functions
├── LICENSE                          # MIT License
├── README.md                        # This file
├── R/                               # R source code
│   ├── floating_chat_module.R       # Floating chat UI/server
│   ├── offcanvas_chat_module.R      # Offcanvas chat UI/server
│   ├── settings_module.R            # API settings (BYOK)
├── inst/                            # Installed files
│   ├── examples/                    # Demo applications
│   │   ├── floating_chat_demo.R     # Minimal floating chat
│   │   ├── byok_floating_chat.R     # BYOK implementation
│   │   ├── offcanvas_chat_demo.R    # Offcanvas demo
│   │   └── byok_offcanvas_chat.R    # BYOK + offcanvas
│   └── www/                         # Documentation & assets
│       ├── BYOK_GUIDE.md            # BYOK implementation guide
│       ├── FLOATING_CHAT_QUICKSTART.md
│       └── floating_chat.css        # Floating chat styles
├── tests/                           # Unit tests
│   └── testthat/
│       ├── test-floating_chat.R
│       └── test-settings_module.R
├── man/                             # Generated documentation
├── memory-bank/                     # Project documentation
└── dev/                             # Development scripts
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
```

### Building Documentation

```r
# Generate documentation from roxygen comments
devtools::document()
```

## API Reference

### Floating Chat Module (Primary)

#### `floating_chat_ui(id, ...)`

Creates a modern floating chat interface with a trigger button and overlay panel.

**Key Parameters:**
- `id` - Namespace ID for the module (required)
- `title` - Header title (default: "Chat Assistant")
- `trigger_position` - Corner placement: "bottom-right" (default), "bottom-left", "top-right", "top-left"
- `trigger_icon` - FontAwesome icon name (default: "comments")
- `trigger_size` - Button size in pixels (default: 60)
- `panel_width` - Panel width in pixels (default: 400)
- `panel_height` - Panel height in pixels (default: 600)
- `theme` - Color theme: "light" (default) or "dark"
- `welcome_message` - Initial greeting message (optional)
- `enable_minimize` - Show minimize button (default: TRUE)
- `enable_maximize` - Show maximize button (default: TRUE)
- `header_actions` - Custom UI elements for header (e.g., settings, clear buttons)
- `chat_ui_args` - Additional arguments passed to shinychat

**Example:**
```r
floating_chat_ui(
  id = "assistant",
  title = "AI Helper",
  trigger_position = "bottom-right",
  panel_width = 450,
  theme = "light",
  welcome_message = "👋 How can I help?",
  suggested_prompts = c("Explain this data", "Plot the results", "Summarize findings"),
  header_actions = actionButton("clear", icon("trash"))
)
```

#### `floating_chat_server(id, client)`

Server logic for the floating chat module.

**Parameters:**
- `id` - Namespace ID matching the UI (required)
- `client` - ellmer chat client (reactive or static)

**Returns:** Chat server object from shinychat

**Example:**
```r
floating_chat_server(
  id = "assistant",
  client = ellmer::chat_github(
    system_prompt = "You are a helpful assistant."
  )
)
```

### API Settings Module (BYOK)

#### `api_settings_ui(id, ...)`

Creates a UI for configuring LLM provider API keys and model selection.

**Parameters:**
- `id` - Namespace ID for the module (required)
- `default_provider` - Initial provider: "github" (default), "openai", "anthropic", "google", "azure", "ollama"
- `show_advanced` - Show advanced settings like temperature (default: FALSE)
- `inline` - Display inline vs in modal (default: FALSE)

**Example:**
```r
api_settings_ui(
  id = "settings",
  default_provider = "github",
  show_advanced = TRUE
)
```

#### `api_settings_server(id, ...)`

Server logic for API settings configuration.

**Parameters:**
- `id` - Namespace ID matching the UI (required)
- `default_system_prompt` - Default system prompt for the LLM

**Returns:** Reactive list with:
- `$client()` - Configured ellmer client
- `$provider()` - Selected provider name
- `$model()` - Selected model name
- `$is_configured()` - Boolean indicating if settings are complete

**Example:**
```r
settings <- api_settings_server(
  id = "settings",
  default_system_prompt = "You are a helpful data analyst."
)

# Use in chat module
observe({
  req(settings$is_configured())
  floating_chat_server("chat", client = settings$client())
})
```

### Offcanvas Chat Module (Alternative Layout)

#### `offcanvas_chat_ui(id, ...)`

Creates a slide-out panel chat interface (edge-anchored).

**Key Parameters:**
- `id` - Namespace ID for the module (required)
- `title` - Panel header title
- `placement` - Edge position: "end" (right), "start" (left), "top", "bottom"
- `width` - Panel width in pixels (for side placement)
- `open_label` - Text for trigger button
- `open_icon` - Icon for trigger button
- `header_actions` - Custom UI elements for header

#### `offcanvas_chat_server(id, client)`

Server logic for the offcanvas chat module.

**Parameters:**
- `id` - Namespace ID matching the UI
- `client` - ellmer chat client

### Utilities

## BYOK (Bring Your Own Key)

Give users full control over their LLM provider and API keys with the built-in settings module.

### Supported Providers

| Provider | Models | API Key Source |
|----------|--------|----------------|
| **GitHub Models** | GPT-4o, GPT-4o-mini, Llama 3, Phi-3.5, Mistral | GitHub Personal Access Token |
| **OpenAI** | GPT-4, GPT-4-turbo, GPT-3.5-turbo, o1 | OpenAI API Key |
| **Anthropic** | Claude 3.5 Sonnet, Claude 3 Opus/Haiku | Anthropic API Key |
| **Google Gemini** | Gemini 1.5 Pro/Flash | Google AI API Key |
| **Azure OpenAI** | GPT-4, GPT-3.5 (custom deployments) | Azure Endpoint + Key |
| **Ollama** | Any local model | Local instance (no key) |

### Implementation Patterns

#### Pattern 1: Settings Module (Recommended)

Complete BYOK implementation with UI:

```r
ui <- page_fluid(
  # Settings button in chat header
  floating_chat_ui(
    id = "chat",
    header_actions = actionButton(
      "settings_btn", 
      icon("gear"),
      `data-bs-toggle` = "modal",
      `data-bs-target` = "#settingsModal"
    )
  ),
  
  # Settings modal
  tags$div(
    # class = "modal fade",
    id = "settingsModal",
    api_settings_ui("settings")
  )
)

server <- function(input, output, session) {
  settings <- api_settings_server("settings")
  
  observe({
    req(settings$is_configured())
    floating_chat_server("chat", client = settings$client())
  })
}

shinyApp(ui, server)
```

#### Pattern 2: Environment Variables

Simple BYOK for trusted environments:

```r
# Set in .Renviron or environment
Sys.setenv(OPENAI_API_KEY = "sk-...")

# Client auto-detects from environment
server <- function(input, output, session) {
  floating_chat_server(
    "chat",
    client = ellmer::chat_openai()  # Uses OPENAI_API_KEY
  )
}
```

#### Pattern 3: Dynamic Provider Selection

User chooses provider without API key input:

```r
ui <- page_fluid(
  selectInput("provider", "Provider", c("GitHub", "OpenAI", "Claude")),
  floating_chat_ui("chat")
)

server <- function(input, output, session) {
  client <- reactive({
    switch(input$provider,
      "GitHub" = ellmer::chat_github(),
      "OpenAI" = ellmer::chat_openai(),
      "Claude" = ellmer::chat_claude()
    )
  })
  
  observe({
    req(client())
    floating_chat_server("chat", client = client())
  })
}

shinyApp(ui, server)
```

### Example Apps

Run complete BYOK examples:

```r
# Full BYOK with settings UI
shiny::runApp(system.file("examples/byok_floating_chat.R", package = "chatbotr"))

# Offcanvas variant
shiny::runApp(system.file("examples/byok_offcanvas_chat.R", package = "chatbotr"))
```

### Documentation

- [BYOK Implementation Guide](inst/www/BYOK_GUIDE.md)
- [Floating Chat Quickstart](inst/www/FLOATING_CHAT_QUICKSTART.md)
- [API Settings Reference](man/api_settings_ui.Rd)

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
