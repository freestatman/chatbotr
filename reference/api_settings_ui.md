# API Settings UI Module

Creates a UI for configuring API keys and selecting LLM providers and
models. Supports multiple providers (GitHub Models, OpenAI, Anthropic,
Google Gemini, etc.) with secure key input and model selection.

## Usage

``` r
api_settings_ui(
  id,
  default_provider = "github",
  show_advanced = FALSE,
  inline = FALSE
)
```

## Arguments

- id:

  Namespace ID for the module

- default_provider:

  Default provider to show (default: "github")

- show_advanced:

  Show advanced settings like temperature, max_tokens (default: FALSE)

- inline:

  Display settings inline vs in a modal (default: FALSE)

## Value

A Shiny UI element containing the settings interface

## Examples

``` r
if (FALSE) { # \dontrun{
library(shiny)
ui <- fluidPage(
  api_settings_ui("settings")
)
} # }
```
