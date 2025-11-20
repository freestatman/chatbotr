# BYOK (Bring Your Own Key) Guide

## Overview

The chatbotr package supports **Bring Your Own Key (BYOK)** functionality, allowing you to use your own API keys and tokens with various LLM providers. This gives you complete control over your AI provider, model selection, and associated costs.

## Supported Providers

### 1. GitHub Models
- **Provider ID:** `github`
- **Authentication:** GitHub Personal Access Token
- **Environment Variable:** `GITHUB_TOKEN`
- **Available Models:**
  - GPT-4o
  - GPT-4o Mini
  - GPT-4 Turbo
  - o1 Preview
  - o1 Mini
  - Phi-3.5
  - Llama 3.1 (405B, 70B)
  - Mistral Large

**How to get your token:**
1. Go to https://github.com/settings/tokens
2. Generate a new token with appropriate permissions
3. Use the token in the API settings

### 2. OpenAI
- **Provider ID:** `openai`
- **Authentication:** OpenAI API Key
- **Environment Variable:** `OPENAI_API_KEY`
- **Available Models:**
  - GPT-4o
  - GPT-4o Mini
  - GPT-4 Turbo
  - GPT-4
  - GPT-3.5 Turbo
  - o1 Preview
  - o1 Mini

**How to get your key:**
1. Visit https://platform.openai.com/api-keys
2. Create a new API key
3. Copy and use in the application

### 3. Anthropic (Claude)
- **Provider ID:** `anthropic`
- **Authentication:** Anthropic API Key
- **Environment Variable:** `ANTHROPIC_API_KEY`
- **Available Models:**
  - Claude 3.5 Sonnet
  - Claude 3 Opus
  - Claude 3 Sonnet
  - Claude 3 Haiku

**How to get your key:**
1. Go to https://console.anthropic.com/
2. Navigate to API Keys section
3. Generate a new key

### 4. Google Gemini
- **Provider ID:** `google`
- **Authentication:** Google API Key
- **Environment Variable:** `GOOGLE_API_KEY`
- **Available Models:**
  - Gemini 1.5 Pro
  - Gemini 1.5 Flash
  - Gemini 1.0 Pro

**How to get your key:**
1. Visit https://makersuite.google.com/app/apikey
2. Create a new API key
3. Use in the application

### 5. Azure OpenAI
- **Provider ID:** `azure`
- **Authentication:** Azure API Key + Endpoint
- **Environment Variables:** 
  - `AZURE_OPENAI_API_KEY`
  - `AZURE_OPENAI_ENDPOINT`
- **Available Models:**
  - GPT-4o
  - GPT-4o Mini
  - GPT-4 Turbo
  - GPT-4
  - GPT-3.5 Turbo

**How to set up:**
1. Create an Azure OpenAI resource
2. Deploy a model
3. Get the endpoint and key from the Azure portal

### 6. Ollama (Local)
- **Provider ID:** `ollama`
- **Authentication:** None (local installation)
- **Default Host:** `http://localhost:11434`
- **Available Models:**
  - Llama 3.2, 3.1, 3
  - Mistral
  - Mixtral
  - Phi-3
  - Gemma 2
  - CodeLlama

**How to set up:**
1. Install Ollama from https://ollama.ai/
2. Pull models: `ollama pull llama3.2`
3. Ensure Ollama is running locally
4. Connect through the application

## Usage Patterns

### Pattern 1: Settings Module with Modal (Floating Chat)

This pattern uses a modal dialog for settings configuration:

```r
library(shiny)
library(bslib)
library(chatbotr)

ui <- page_fluid(
  theme = bs_theme(version = 5),
  
  # Your app content
  h1("My App"),
  
  # Floating chat with settings button
  floating_chat_ui(
    id = "chat",
    title = "AI Assistant",
    header_actions = actionButton(
      "open_settings",
      NULL,
      icon = icon("cog"),
      `data-bs-toggle` = "modal",
      `data-bs-target` = "#settingsModal"
    ),
    chat_ui_fun = shinychat::chat_mod_ui
  ),
  
  # Settings Modal
  tags$div(
    class = "modal fade",
    id = "settingsModal",
    tags$div(
      class = "modal-dialog",
      tags$div(
        class = "modal-content",
        tags$div(class = "modal-header", h5("API Settings")),
        tags$div(class = "modal-body", api_settings_ui("settings")),
        tags$div(class = "modal-footer", 
          tags$button(type = "button", class = "btn btn-secondary",
                     `data-bs-dismiss` = "modal", "Close"))
      )
    )
  )
)

server <- function(input, output, session) {
  # Configure API settings
  settings <- api_settings_server("settings")
  
  # Initialize chat with configured client
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

### Pattern 2: Settings Card (Offcanvas Chat)

This pattern displays settings in a collapsible card:

```r
library(shiny)
library(bslib)
library(chatbotr)

ui <- page_fluid(
  theme = bs_theme(version = 5),
  
  # Settings card
  div(
    class = "card mb-4",
    div(class = "card-header", h5("API Configuration")),
    div(
      class = "card-body",
      api_settings_ui("settings", show_advanced = TRUE)
    )
  ),
  
  # Status indicator
  uiOutput("status"),
  
  # Offcanvas chat
  offcanvas_chat_ui(
    id = "chat",
    title = "Assistant",
    chat_ui_fun = shinychat::chat_mod_ui
  )
)

server <- function(input, output, session) {
  settings <- api_settings_server("settings")
  
  output$status <- renderUI({
    if (settings$is_configured()) {
      div(class = "alert alert-success", 
          sprintf("Connected: %s", settings$provider()))
    } else {
      div(class = "alert alert-warning", 
          "Configure API settings to start")
    }
  })
  
  observe({
    req(settings$is_configured())
    offcanvas_chat_server(
      "chat",
      chat_server_fun = shinychat::chat_mod_server,
      client = settings$client()
    )
  })
}

shinyApp(ui, server)
```

### Pattern 3: Environment Variables (Traditional)

For production deployments, you can still use environment variables:

```r
library(shiny)
library(bslib)
library(chatbotr)

ui <- page_fluid(
  floating_chat_ui(
    id = "chat",
    chat_ui_fun = shinychat::chat_mod_ui
  )
)

server <- function(input, output, session) {
  # Client reads from environment variables automatically
  github <- ellmer::chat_github()
  
  floating_chat_server(
    "chat",
    chat_server_fun = shinychat::chat_mod_server,
    client = github
  )
}

shinyApp(ui, server)
```

## Dynamic Model Discovery

### Automatic Model Fetching

The BYOK settings module can dynamically fetch available models from providers using your API credentials. This ensures you always see the most current models available to your account.

**Supported for:**
- GitHub Models (`ellmer::models_github()`)
- OpenAI (`ellmer::models_openai()`)
- Anthropic (`ellmer::models_anthropic()`)
- Google Gemini (`ellmer::models_google_gemini()`)
- Ollama (`ellmer::models_ollama()`)

### How It Works

1. **Default Models**: When you first open settings, you'll see a curated list of popular models for each provider
2. **Refresh Models Button**: Click "Refresh Models" to fetch the complete list of models available to your API key
3. **Status Indicator**: See how many models were loaded or if you're using defaults

### Example Workflow

```r
# 1. Open settings modal/card
# 2. Select provider (e.g., "OpenAI")
# 3. Enter your API key
# 4. Click "Refresh Models" button
# 5. The model dropdown updates with all models available to your account
# 6. Select your preferred model
# 7. Save settings
```

### Benefits

- **Always Current**: See new models as soon as they're available to your account
- **Account-Specific**: Only see models you have access to
- **Fallback Safe**: If fetching fails, defaults are always available
- **Manual Control**: Refresh on-demand to avoid unnecessary API calls

### Troubleshooting Model Fetching

**"Failed to load models"**
- Check your API key is correct
- Ensure you have internet connectivity
- Verify your account has access to the API
- Fallback to default models will be used automatically

**Models not updating**
- Click "Refresh Models" button explicitly
- Check the provider supports dynamic model listing
- Azure OpenAI doesn't support listing (uses default models)

## Security Best Practices

### 1. Session-Only Storage
API keys are stored only in the Shiny session and are never:
- Written to disk
- Committed to version control
- Shared between users
- Persisted after session ends

### 2. Environment Variables for Production
For production deployments, use environment variables:

```bash
# .Renviron file (add to .gitignore!)
GITHUB_TOKEN=ghp_yourtoken
OPENAI_API_KEY=sk-yourkey
ANTHROPIC_API_KEY=sk-ant-yourkey
```

### 3. Secure Input Fields
The settings module uses `passwordInput()` to mask API keys in the UI.

### 4. Connection Testing
Always test connections before using in production:

```r
# In your server
observeEvent(settings$is_configured(), {
  if (settings$is_configured()) {
    # Test the connection
    # Then proceed with chat initialization
  }
})
```

## Advanced Configuration

### Custom System Prompts

```r
settings <- api_settings_server(
  "settings",
  default_system_prompt = "You are a specialized assistant for data analysis."
)
```

### Temperature and Token Controls

Enable advanced settings in the UI:

```r
api_settings_ui(
  "settings",
  show_advanced = TRUE  # Shows temperature and max_tokens sliders
)
```

### Multiple Chat Instances

You can create multiple chat instances with different configurations:

```r
server <- function(input, output, session) {
  settings1 <- api_settings_server("settings1")
  settings2 <- api_settings_server("settings2")
  
  observe({
    req(settings1$is_configured())
    floating_chat_server("chat1", shinychat::chat_mod_server, 
                        client = settings1$client())
  })
  
  observe({
    req(settings2$is_configured())
    offcanvas_chat_server("chat2", shinychat::chat_mod_server,
                         client = settings2$client())
  })
}
```

## Error Handling

The settings module provides built-in error handling:

### Invalid Keys
```r
# Automatically caught and displayed to user
config$test_status <- list(
  success = FALSE,
  message = "Invalid API key"
)
```

### Missing Configuration
```r
# Use req() to prevent execution until configured
observe({
  req(settings$is_configured())
  # Safe to use settings$client() here
})
```

### Connection Failures
```r
# Test connection before use
observeEvent(input$test_connection, {
  # Attempts test query and reports status
})
```

## Troubleshooting

### "Failed to create client"
- Verify your API key is correct
- Check that you have an active subscription/credits
- Ensure environment variables are set correctly (if using that method)

### "No response from API"
- Check your internet connection
- Verify the provider's API status
- Test with a smaller model first

### "Connection timeout"
- For Azure, verify your endpoint URL is correct
- For Ollama, ensure the service is running: `ollama serve`
- Check firewall settings

### Model not available
- Verify you have access to the selected model
- Some models require special access or waitlist approval
- Try a different model from the same provider

## Examples

Complete working examples are available in the package:

```r
# Floating chat with BYOK
system.file("examples/byok_floating_chat.R", package = "chatbotr")

# Offcanvas chat with BYOK
system.file("examples/byok_offcanvas_chat.R", package = "chatbotr")
```

Run examples directly:

```r
# Run floating chat example
source(system.file("examples/byok_floating_chat.R", package = "chatbotr"))

# Run offcanvas example
source(system.file("examples/byok_offcanvas_chat.R", package = "chatbotr"))
```

## API Reference

See the following documentation for detailed function reference:

- `?api_settings_ui` - Settings UI component
- `?api_settings_server` - Settings server logic
- `?floating_chat_ui` - Floating chat interface
- `?floating_chat_server` - Floating chat server
- `?offcanvas_chat_ui` - Offcanvas chat interface
- `?offcanvas_chat_server` - Offcanvas chat server

## Support

For issues or questions:
- GitHub Issues: https://github.com/freestatman/chatbotr/issues
- Package Documentation: `?chatbotr`
