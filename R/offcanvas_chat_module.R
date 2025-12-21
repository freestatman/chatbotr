#' Offcanvas Chat UI Module
#'
#' @description
#' Creates an offcanvas (slide-out) panel containing a chat interface.
#' The offcanvas can slide in from any side of the screen.
#'
#' @param id Namespace ID for the module
#' @param title Title displayed in the offcanvas header (default: "Chat")
#' @param placement Position of the offcanvas: "end" (right), "start" (left),
#'   "bottom", or "top" (default: "end")
#' @param width Width in pixels for side placement (default: 420)
#' @param open_label Text label for the button that opens the chat (default: "Chat")
#' @param open_class CSS classes for the open button (default: "btn btn-dark")
#' @param open_icon Optional icon name for the open button (e.g., "comments")
#' @param chat_ui_args Named list of additional arguments passed to shinychat::chat_mod_ui
#' @param welcome_message Optional welcome message to display when chat is first opened.
#'   If provided, this will be passed to the chat UI function via chat_ui_args.
#' @param header_right Optional UI elements to display in the header's right side
#'
#' @return A Shiny UI tagList containing the open button and offcanvas panel
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(shiny)
#' library(bslib)
#'
#' ui <- page_fluid(
#'   theme = bs_theme(version = 5),
#'   h3("My App"),
#'   offcanvas_chat_ui(
#'     id = "chat",
#'     title = "Assistant",
#'     placement = "end",
#'     welcome_message = "Welcome! How can I assist you?"
#'   )
#' )
#' }
offcanvas_chat_ui <- function(
    id,
    title = "Chat",
    placement = c("end", "start", "bottom", "top"),
    width = 420,
    open_label = "Chat",
    open_class = "btn btn-dark",
    open_icon = NULL,
    chat_ui_args = list(),
    welcome_message = NULL,
    header_right = NULL) {
  placement <- match.arg(placement)
  ns <- shiny::NS(id)

  # Add welcome_message to chat_ui_args if provided
  if (!is.null(welcome_message)) {
    chat_ui_args$messages <- welcome_message
  }

  canvas_id <- ns("chat_canvas")
  label_id <- ns("chat_canvas_label")

  # Button to open the offcanvas - Minimal styling
  open_btn <- shiny::tags$button(
    class = open_class,
    type = "button",
    `data-bs-toggle` = "offcanvas",
    `data-bs-target` = paste0("#", canvas_id),
    `aria-controls` = canvas_id,
    shiny::tagList(
      if (!is.null(open_icon)) shiny::icon(open_icon),
      if (!is.null(open_icon) && nchar(open_label) > 0) " ",
      open_label
    )
  )

  # Optional right-side header content (e.g., clear button)
  header_right <- header_right %||% shiny::tagList()

  # Offcanvas header
  header <- shiny::tags$div(
    class = "offcanvas-header",
    style = "border-bottom: 1px solid #e5e5e5;",
    shiny::tags$h5(
      class = "offcanvas-title",
      id = label_id,
      style = "font-weight: 500; font-size: 0.9rem;",
      title
    ),
    shiny::tags$div(
      class = "ms-auto d-flex gap-2 align-items-center",
      header_right
    ),
    shiny::tags$button(
      type = "button",
      class = "btn-close",
      `data-bs-dismiss` = "offcanvas",
      `aria-label` = "Close"
    )
  )

  # Chat UI content goes into the body
  chat_ui <- do.call(
    shinychat::chat_mod_ui,
    c(list(id = ns("chat")), chat_ui_args)
  )

  body <- shiny::tags$div(
    class = "offcanvas-body p-0 d-flex flex-column",
    chat_ui
  )

  # Format dimensions (handle both px and viewport units)
  format_dimension <- function(dim) {
    if (is.numeric(dim)) {
      paste0(dim, "px")
    } else {
      dim
    }
  }

  # Offcanvas container
  oc_class <- paste("offcanvas", paste0("offcanvas-", placement))
  oc_style <- if (placement %in% c("start", "end")) {
    paste0("--bs-offcanvas-width:", format_dimension(width), ";")
  } else {
    NULL
  }

  offcanvas_div <- shiny::tags$div(
    class = oc_class,
    tabindex = "-1",
    id = canvas_id,
    `aria-labelledby` = label_id,
    `data-bs-scroll` = "true",
    style = oc_style,
    header,
    body
  )

  # Minimal CSS for offcanvas styling
  css_code <- shiny::tags$style(shiny::HTML("
    .offcanvas-header {
      padding: 0.875rem 1rem;
      background: #fff;
    }
    .offcanvas-body {
      background: #fff;
    }
    .btn-ghost {
      background: transparent;
      border: none;
      color: #737373;
      width: 2rem;
      height: 2rem;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      border-radius: 6px;
      cursor: pointer;
      transition: all 0.15s ease;
    }
    .btn-ghost:hover {
      background: rgba(0,0,0,0.05);
      color: #171717;
    }
  "))

  shiny::tagList(css_code, open_btn, offcanvas_div)
}

#' Offcanvas Chat Server Module
#'
#' @description
#' Server logic for the offcanvas chat module. This function wraps
#' another chat server module (like shinychat's server) within the
#' offcanvas namespace.
#'
#' @param id Namespace ID matching the UI module
#' @param client Chat client object (from ellmer)
#' @param ... Additional arguments passed to chat_mod_server
#'
#' @return Returns the result of the chat server function
#'
#' @export
offcanvas_chat_server <- function(
    id,
    client,
    ...) {
  shiny::moduleServer(id, function(input, output, session) {
    shinychat::chat_mod_server("chat", client, ...)
  })
}

`%||%` <- function(x, y) if (is.null(x)) y else x
