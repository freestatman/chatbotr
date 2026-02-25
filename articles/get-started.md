# Get started with chatbotr

`chatbotr` provides a floating chat interface for Shiny apps. It is
designed to stay out of the way until you need it.

## Basic usage

The simplest way to add a chat bubble is using
[`floating_chat_ui()`](https://freestatman.github.io/chatbotr/reference/floating_chat_ui.md)
and
[`floating_chat_server()`](https://freestatman.github.io/chatbotr/reference/floating_chat_server.md).
You must provide an `ellmer` chat client.

``` r
library(shiny)
library(bslib)
library(chatbotr)

ui <- page_fluid(
  floating_chat_ui("chat")
)

server <- function(input, output, session) {
  # Requires GITHUB_PAT if using chat_github()
  chat <- ellmer::chat_github()
  floating_chat_server("chat", client = chat)
}

shinyApp(ui, server)
```

## Offcanvas interface

If you prefer a slide-out panel, use the `offcanvas_*` variants:

``` r
ui <- page_fluid(
  offcanvas_chat_ui("chat")
)

server <- function(input, output, session) {
  floating_chat_server("chat", client = ellmer::chat_github())
}
```

## Let users bring their own key

A common pattern is to let users configure their own LLM client at
runtime. `chatbotr` provides
[`api_settings_ui()`](https://freestatman.github.io/chatbotr/reference/api_settings_ui.md)
and
[`api_settings_server()`](https://freestatman.github.io/chatbotr/reference/api_settings_server.md)
for this purpose.

``` r
ui <- page_fluid(
  api_settings_ui("settings"),
  floating_chat_ui("chat")
)

server <- function(input, output, session) {
  settings <- api_settings_server("settings")
  
  observe({
    req(settings$is_configured())
    floating_chat_server("chat", client = settings$client())
  })
}
```

## Requirements

Ensure you are using `ellmer (>= 0.4.0.9000)`.

``` r
pak::pak("tidyverse/ellmer")
```
