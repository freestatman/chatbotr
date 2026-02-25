# API Settings Server Module

Server logic for API settings configuration. Handles provider selection,
API key validation, model selection, and client creation.

## Usage

``` r
api_settings_server(id, default_system_prompt = NULL)
```

## Arguments

- id:

  Namespace ID matching the UI module

- default_system_prompt:

  Default system prompt for the LLM (optional)

## Value

A reactive list containing:

- client: Configured ellmer client (reactive)

- provider: Selected provider (reactive)

- model: Selected model (reactive)

- is_configured: Whether settings are valid (reactive)

## Examples

``` r
if (FALSE) { # \dontrun{
server <- function(input, output, session) {
  settings <- api_settings_server("settings")

  # Use the configured client
  observe({
    if (settings$is_configured()) {
      client <- settings$client()
      # Use client with shinychat
    }
  })
}
} # }
```
