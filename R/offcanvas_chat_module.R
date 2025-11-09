offcanvas_chat_ui <- function(
  id,
  title = "Chat",
  placement = c("end", "start", "bottom", "top"),
  width = 420,
  open_label = "Chat",
  open_class = "btn btn-primary",
  open_icon = NULL,
  chat_ui_fun,
  chat_ui_args = list(),
  header_right = NULL
) {
  stopifnot(is.function(chat_ui_fun))
  placement <- match.arg(placement)
  ns <- shiny::NS(id)

  canvas_id <- ns("chat_canvas")
  label_id <- ns("chat_canvas_label")

  # Button to open the offcanvas
  open_btn <- shiny::tags$button(
    class = open_class,
    type = "button",
    `data-bs-toggle` = "offcanvas",
    `data-bs-target` = paste0("#", canvas_id),
    `aria-controls` = canvas_id,
    shiny::tagList(
      if (!is.null(open_icon)) shiny::icon(open_icon),
      open_label
    )
  )

  # Optional right-side header content (e.g., clear button)
  header_right <- header_right %||% shiny::tagList()

  # Offcanvas header
  header <- shiny::tags$div(
    class = "offcanvas-header",
    shiny::tags$h5(class = "offcanvas-title", id = label_id, title),
    shiny::tags$div(
      class = "ms-auto d-flex gap-2 align-items-center",
      header_right
    ),
    shiny::tags$button(
      type = "button",
      class = "btn-close text-reset",
      `data-bs-dismiss` = "offcanvas",
      `aria-label` = "Close"
    )
  )

  # Chat UI content goes into the body
  chat_ui <- do.call(
    chat_ui_fun,
    c(list(id = ns("chat")), chat_ui_args)
  )

  body <- shiny::tags$div(
    class = "offcanvas-body p-0 d-flex flex-column",
    chat_ui
  )

  # Offcanvas container
  oc_class <- paste("offcanvas", paste0("offcanvas-", placement))
  oc_style <- if (placement %in% c("start", "end")) {
    paste0("--bs-offcanvas-width:", width, "px;")
  } else {
    NULL
  }

  offcanvas_div <- shiny::tags$div(
    class = oc_class,
    tabindex = "-1",
    id = canvas_id,
    `aria-labelledby` = label_id,
    # Allow the body to scroll while offcanvas is open
    `data-bs-scroll` = "true",
    style = oc_style,
    header,
    body
  )

  shiny::tagList(open_btn, offcanvas_div)
}

offcanvas_chat_server <- function(
  id,
  chat_server_fun,
  ...
) {
  stopifnot(is.function(chat_server_fun))
  shiny::moduleServer(id, function(input, output, session) {
    # If the underlying chat server is also a module, pass the child id
    "chat"
    chat_server_fun("chat", ...)
  })
}

`%||%` <- function(x, y) if (is.null(x)) y else x
