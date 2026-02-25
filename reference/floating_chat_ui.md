# Floating Chat UI Module

Creates a floating chat interface with a customizable trigger icon and
collapsible overlay panel. The chat appears as a modern floating window
on top of the main content, similar to common chatbot interfaces.

## Usage

``` r
floating_chat_ui(
  id,
  title = "Chat Assistant",
  trigger_position = c("bottom-right", "bottom-left", "top-right", "top-left"),
  trigger_icon = "comments",
  trigger_size = 60,
  panel_width = 400,
  panel_height = 600,
  panel_offset = 20,
  chat_ui_args = list(),
  welcome_message = NULL,
  suggested_prompts = NULL,
  theme = c("light", "dark"),
  enable_minimize = TRUE,
  enable_maximize = TRUE,
  header_actions = NULL
)
```

## Arguments

- id:

  Namespace ID for the module

- title:

  Title displayed in the chat panel header (default: "Chat Assistant")

- trigger_position:

  Position of the floating trigger icon: "bottom-right", "bottom-left",
  "top-right", or "top-left" (default: "bottom-right")

- trigger_icon:

  Icon name for the trigger button (default: "comments")

- trigger_size:

  Size of the trigger button in pixels (default: 60)

- panel_width:

  Width of the chat panel in pixels (default: 400)

- panel_height:

  Height of the chat panel in pixels (default: 600)

- panel_offset:

  Offset from viewport edges in pixels (default: 20)

- chat_ui_args:

  Named list of additional arguments passed to shinychat::chat_mod_ui()

- welcome_message:

  Optional welcome message to display when chat is first opened. If
  provided, this will be passed to the chat UI function via
  chat_ui_args.

- suggested_prompts:

  Optional vector of suggested prompt strings to display as chips.

- theme:

  Color theme: "light" or "dark" (default: "light")

- enable_minimize:

  Enable minimize functionality (default: TRUE)

- enable_maximize:

  Enable maximize functionality (default: TRUE)

- header_actions:

  Optional UI elements for header actions (e.g., clear button)

## Value

A Shiny UI tagList containing the floating trigger and chat panel

## Examples

``` r
if (FALSE) { # \dontrun{
library(shiny)
library(bslib)

ui <- page_fluid(
  theme = bs_theme(version = 5),
  h3("My App"),
  floating_chat_ui(
    id = "floating_chat",
    title = "AI Assistant",
    trigger_position = "bottom-right",
    welcome_message = "Hello! I'm your AI assistant. How can I help you today?"
  )
)
} # }
```
