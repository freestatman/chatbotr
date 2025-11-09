#' Floating Chat UI Module
#'
#' @description
#' Creates a floating chat interface with a customizable trigger icon and 
#' collapsible overlay panel. The chat appears as a modern floating window
#' on top of the main content, similar to common chatbot interfaces.
#'
#' @param id Namespace ID for the module
#' @param title Title displayed in the chat panel header (default: "Chat Assistant")
#' @param trigger_position Position of the floating trigger icon: 
#'   "bottom-right", "bottom-left", "top-right", or "top-left" (default: "bottom-right")
#' @param trigger_icon Icon name for the trigger button (default: "comments")
#' @param trigger_size Size of the trigger button in pixels (default: 60)
#' @param panel_width Width of the chat panel in pixels (default: 400)
#' @param panel_height Height of the chat panel in pixels (default: 600)
#' @param panel_offset Offset from viewport edges in pixels (default: 20)
#' @param chat_ui_fun Function that generates the chat UI, typically from shinychat
#' @param chat_ui_args Named list of additional arguments passed to chat_ui_fun
#' @param theme Color theme: "light" or "dark" (default: "light")
#' @param enable_minimize Enable minimize functionality (default: TRUE)
#' @param header_actions Optional UI elements for header actions (e.g., clear button)
#'
#' @return A Shiny UI tagList containing the floating trigger and chat panel
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
#'   floating_chat_ui(
#'     id = "floating_chat",
#'     title = "AI Assistant",
#'     trigger_position = "bottom-right",
#'     chat_ui_fun = shinychat::chat_mod_ui
#'   )
#' )
#' }
floating_chat_ui <- function(
  id,
  title = "Chat Assistant",
  trigger_position = c("bottom-right", "bottom-left", "top-right", "top-left"),
  trigger_icon = "comments",
  trigger_size = 60,
  panel_width = 400,
  panel_height = 600,
  panel_offset = 20,
  chat_ui_fun,
  chat_ui_args = list(),
  theme = c("light", "dark"),
  enable_minimize = TRUE,
  header_actions = NULL
) {
  stopifnot(is.function(chat_ui_fun))
  trigger_position <- match.arg(trigger_position)
  theme <- match.arg(theme)
  ns <- shiny::NS(id)

  # Generate IDs
  trigger_id <- ns("trigger")
  panel_id <- ns("panel")
  overlay_id <- ns("overlay")
  
  # Parse position for CSS
  position_parts <- strsplit(trigger_position, "-")[[1]]
  vertical <- position_parts[1]   # top or bottom
  horizontal <- position_parts[2] # left or right
  
  # Trigger button positioning
  trigger_style <- paste0(
    "position: fixed; ",
    "z-index: 1040; ",
    vertical, ": ", panel_offset, "px; ",
    horizontal, ": ", panel_offset, "px; ",
    "width: ", trigger_size, "px; ",
    "height: ", trigger_size, "px; ",
    "border-radius: 50%; ",
    "display: flex; ",
    "align-items: center; ",
    "justify-content: center; ",
    "cursor: pointer; ",
    "transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); ",
    "box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15); "
  )
  
  # Panel positioning based on trigger location
  bg_color <- if (theme == "dark") "#1e293b" else "#ffffff"
  panel_style <- paste0(
    "position: fixed; ",
    "z-index: 1050; ",
    vertical, ": ", panel_offset, "px; ",
    horizontal, ": ", panel_offset, "px; ",
    "width: ", panel_width, "px; ",
    "height: ", panel_height, "px; ",
    "display: none; ",
    "background: ", bg_color, " !important; ",
    "border-radius: 12px; ",
    "overflow: hidden; ",
    "transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); ",
    "box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2); "
  )
  
  # Overlay for closing chat when clicking outside
  overlay_style <- paste0(
    "position: fixed; ",
    "top: 0; ",
    "left: 0; ",
    "width: 100%; ",
    "height: 100%; ",
    "background: rgba(0, 0, 0, 0.3); ",
    "z-index: 1045; ",
    "display: none; ",
    "transition: opacity 0.3s ease; "
  )
  
  # Theme classes
  theme_class <- if (theme == "dark") "floating-chat-dark" else "floating-chat-light"
  
  # Trigger button
  trigger_btn <- shiny::tags$div(
    id = trigger_id,
    class = paste("floating-chat-trigger", theme_class),
    style = trigger_style,
    `data-chat-id` = panel_id,
    shiny::tags$i(
      class = paste("fa fa-", trigger_icon, sep = ""),
      style = "font-size: 28px;"
    )
  )
  
  # Chat panel header
  minimize_btn <- if (enable_minimize) {
    shiny::tags$button(
      class = "btn btn-sm btn-ghost floating-chat-minimize",
      type = "button",
      style = "padding: 4px 8px;",
      shiny::icon("minus")
    )
  } else {
    NULL
  }
  
  header <- shiny::tags$div(
    class = "floating-chat-header",
    style = paste0(
      "padding: 16px 20px; ",
      "border-bottom: 1px solid; ",
      "display: flex; ",
      "align-items: center; ",
      "justify-content: space-between; ",
      "background: ", bg_color, " !important; "
    ),
    shiny::tags$h5(
      style = "margin: 0; font-weight: 600;",
      title
    ),
    shiny::tags$div(
      class = "d-flex gap-2 align-items-center",
      header_actions,
      minimize_btn,
      shiny::tags$button(
        class = "btn btn-sm btn-ghost floating-chat-close",
        type = "button",
        style = "padding: 4px 8px;",
        shiny::icon("times")
      )
    )
  )
  
  # Chat UI content
  chat_ui <- do.call(
    chat_ui_fun,
    c(list(id = ns("chat")), chat_ui_args)
  )
  
  # Chat panel body
  body <- shiny::tags$div(
    class = "floating-chat-body",
    style = paste0(
      "height: calc(100% - 65px); ",
      "overflow: hidden; ",
      "display: flex; ",
      "flex-direction: column; ",
      "background: ", bg_color, " !important; "
    ),
    chat_ui
  )
  
  # Complete chat panel
  panel <- shiny::tags$div(
    id = panel_id,
    class = paste("floating-chat-panel", theme_class),
    style = panel_style,
    `data-minimized` = "false",
    header,
    body
  )
  
  # Overlay
  overlay <- shiny::tags$div(
    id = overlay_id,
    class = "floating-chat-overlay",
    style = overlay_style
  )
  
  # JavaScript for interactions
  js_code <- shiny::tags$script(shiny::HTML(sprintf('
    (function() {
      const triggerId = "%s";
      const panelId = "%s";
      const overlayId = "%s";
      
      function initFloatingChat() {
        const trigger = document.getElementById(triggerId);
        const panel = document.getElementById(panelId);
        const overlay = document.getElementById(overlayId);
        
        if (!trigger || !panel || !overlay) return;
        
        // Open chat
        trigger.addEventListener("click", function() {
          panel.style.display = "flex";
          panel.style.flexDirection = "column";
          overlay.style.display = "block";
          trigger.style.transform = "scale(0)";
          
          // Animate in
          setTimeout(() => {
            panel.style.opacity = "1";
            panel.style.transform = "scale(1)";
            overlay.style.opacity = "1";
          }, 10);
        });
        
        // Close chat
        const closeBtn = panel.querySelector(".floating-chat-close");
        if (closeBtn) {
          closeBtn.addEventListener("click", function() {
            closeChat();
          });
        }
        
        // Minimize chat
        const minimizeBtn = panel.querySelector(".floating-chat-minimize");
        if (minimizeBtn) {
          minimizeBtn.addEventListener("click", function() {
            const isMinimized = panel.getAttribute("data-minimized") === "true";
            if (isMinimized) {
              panel.style.height = "%spx";
              panel.setAttribute("data-minimized", "false");
              minimizeBtn.innerHTML = \'<i class="fa fa-minus"></i>\';
            } else {
              panel.style.height = "65px";
              panel.setAttribute("data-minimized", "true");
              minimizeBtn.innerHTML = \'<i class="fa fa-expand"></i>\';
            }
          });
        }
        
        // Close on overlay click
        overlay.addEventListener("click", function() {
          closeChat();
        });
        
        function closeChat() {
          panel.style.opacity = "0";
          panel.style.transform = "scale(0.95)";
          overlay.style.opacity = "0";
          
          setTimeout(() => {
            panel.style.display = "none";
            overlay.style.display = "none";
            trigger.style.transform = "scale(1)";
          }, 300);
        }
      }
      
      // Initialize when document is ready
      if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", initFloatingChat);
      } else {
        initFloatingChat();
      }
    })();
  ', trigger_id, panel_id, overlay_id, panel_height)))
  
  shiny::tagList(
    overlay,
    trigger_btn,
    panel,
    js_code
  )
}

#' Floating Chat Server Module
#'
#' @description
#' Server logic for the floating chat module. This function wraps
#' another chat server module (like shinychat's server) within the
#' floating chat namespace.
#'
#' @param id Namespace ID matching the UI module
#' @param chat_server_fun Server function for the chat module, typically from shinychat
#' @param ... Additional arguments passed to chat_server_fun (e.g., client, system_prompt)
#'
#' @return Returns the result of the chat server function
#'
#' @export
#'
#' @examples
#' \dontrun{
#' server <- function(input, output, session) {
#'   github <- ellmer::chat_github()
#'   
#'   floating_chat_server(
#'     id = "floating_chat",
#'     chat_server_fun = shinychat::chat_mod_server,
#'     client = github
#'   )
#' }
#' }
floating_chat_server <- function(
  id,
  chat_server_fun,
  ...
) {
  stopifnot(is.function(chat_server_fun))
  shiny::moduleServer(id, function(input, output, session) {
    # Wrap the underlying chat server within our namespace
    chat_server_fun("chat", ...)
  })
}

`%||%` <- function(x, y) if (is.null(x)) y else x
