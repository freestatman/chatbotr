# Offcanvas Chat UI Module

Creates an offcanvas (slide-out) panel containing a chat interface. The
offcanvas can slide in from any side of the screen.

## Usage

``` r
offcanvas_chat_ui(
  id,
  title = "Chat",
  placement = c("end", "start", "bottom", "top"),
  width = 420,
  open_label = "Chat",
  open_class = "btn btn-dark",
  open_icon = NULL,
  chat_ui_args = list(),
  welcome_message = NULL,
  header_right = NULL,
  suggested_prompts = NULL
)
```

## Arguments

- id:

  Namespace ID for the module

- title:

  Title displayed in the offcanvas header (default: "Chat")

- placement:

  Position of the offcanvas: "end" (right), "start" (left), "bottom", or
  "top" (default: "end")

- width:

  Width in pixels for side placement (default: 420)

- open_label:

  Text label for the button that opens the chat (default: "Chat")

- open_class:

  CSS classes for the open button (default: "btn btn-dark")

- open_icon:

  Optional icon name for the open button (e.g., "comments")

- chat_ui_args:

  Named list of additional arguments passed to shinychat::chat_mod_ui

- welcome_message:

  Optional welcome message to display when chat is first opened. If
  provided, this will be passed to the chat UI function via
  chat_ui_args.

- header_right:

  Optional UI elements to display in the header's right side

- suggested_prompts:

  Optional vector of suggested prompt strings to display as chips.

## Value

A Shiny UI tagList containing the open button and offcanvas panel

## Examples

``` r
if (FALSE) { # \dontrun{
library(shiny)
library(bslib)

ui <- page_fluid(
  theme = bs_theme(version = 5),
  h3("My App"),
  offcanvas_chat_ui(
    id = "chat",
    title = "Assistant",
    placement = "end",
    welcome_message = "Welcome! How can I assist you?"
  )
)
} # }
```
