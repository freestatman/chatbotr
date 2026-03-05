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
#' @param chat_ui_args Named list of additional arguments passed to shinychat::chat_mod_ui()
#' @param welcome_message Optional welcome message to display when chat is first opened.
#'   If provided, this will be passed to the chat UI function via chat_ui_args.
#' @param suggested_prompts Optional vector of suggested prompt strings to display as chips.
#' @param theme Color theme: "light" or "dark" (default: "light")
#' @param enable_maximize Enable maximize functionality (default: TRUE)
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
#'     welcome_message = "Hello! I'm your AI assistant. How can I help you today?"
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
  chat_ui_args = list(),
  welcome_message = NULL,
  suggested_prompts = NULL,
  theme = c("light", "dark"),
  enable_maximize = TRUE,
  header_actions = NULL
) {
  trigger_position <- match.arg(trigger_position)
  theme <- match.arg(theme)
  ns <- shiny::NS(id)

  # Add welcome_message to chat_ui_args if provided
  if (!is.null(welcome_message)) {
    chat_ui_args$messages <- welcome_message
  }

  # Generate IDs
  trigger_id <- ns("trigger")
  panel_id <- ns("panel")
  overlay_id <- ns("overlay")

  # Parse position for CSS
  position_parts <- strsplit(trigger_position, "-")[[1]]
  vertical <- position_parts[1] # top or bottom
  horizontal <- position_parts[2] # left or right

  panel_width_css <- format_dimension(panel_width)
  panel_height_css <- format_dimension(panel_height)

  # Positioning variables for CSS
  pos_vars <- sprintf(
    "--chat-pos-%s: %dpx; --chat-pos-%s: %dpx; --chat-trigger-size: %dpx; --chat-panel-width: %s; --chat-panel-height: %s;",
    vertical,
    panel_offset,
    horizontal,
    panel_offset,
    trigger_size,
    panel_width_css,
    panel_height_css
  )

  # Theme classes
  theme_class <- if (theme == "dark") {
    "floating-chat-dark"
  } else {
    "floating-chat-light"
  }

  # Trigger button
  trigger_btn <- shiny::tags$div(
    id = trigger_id,
    class = paste("floating-chat-trigger", theme_class),
    style = pos_vars,
    `data-chat-id` = panel_id,
    `role` = "button",
    `aria-label` = "Open chat assistant",
    `tabindex` = "0",
    shiny::tags$i(
      class = paste("fa fa-", trigger_icon, sep = ""),
      `aria-hidden` = "true"
    )
  )

  # Chat panel header - Minimal styling
  maximize_btn <- if (enable_maximize) {
    shiny::tags$button(
      class = "btn btn-sm btn-ghost floating-chat-maximize",
      type = "button",
      `aria-label` = "Maximize chat",
      shiny::icon("expand-arrows-alt")
    )
  } else {
    NULL
  }

  header <- shiny::tags$div(
    class = "floating-chat-header chatbotr-header",
    shiny::tags$h5(title),
    shiny::tags$div(
      class = "d-flex gap-1 align-items-center",
      header_actions,
      maximize_btn,
      shiny::tags$button(
        class = "btn btn-sm btn-ghost floating-chat-close",
        type = "button",
        `aria-label` = "Close chat",
        shiny::icon("times")
      )
    )
  )

  # Suggested Prompts Area
  prompts_ui <- chat_prompts_ui(suggested_prompts)

  # Chat UI content
  chat_ui <- do.call(
    shinychat::chat_mod_ui,
    c(list(id = ns("chat")), chat_ui_args)
  )

  # Chat panel body
  body <- shiny::tags$div(
    class = "floating-chat-body chatbotr-body",
    chat_ui,
    prompts_ui
  )

  # Complete chat panel with accessibility attributes
  panel <- shiny::tags$div(
    id = panel_id,
    class = paste("floating-chat-panel chatbotr-panel", theme_class),
    style = pos_vars,
    `data-maximized` = "false",
    `data-original-width` = panel_width_css,
    `data-original-height` = panel_height_css,
    `data-original-position` = trigger_position,
    `role` = "dialog",
    `aria-label` = "Chat assistant dialog",
    `aria-modal` = "true",
    header,
    body
  )

  # Overlay
  overlay <- shiny::tags$div(
    id = overlay_id,
    class = "floating-chat-overlay"
  )

  # Inline JavaScript for interactions (reliable, no async loading issues)
  js_code <- shiny::tags$script(shiny::HTML(sprintf(
    '
    (function() {
      const triggerId = "%s";
      const panelId = "%s";
      const overlayId = "%s";

      function initFloatingChat() {
        const trigger = document.getElementById(triggerId);
        const panel = document.getElementById(panelId);
        const overlay = document.getElementById(overlayId);

        if (!trigger || !panel || !overlay) return;

        function openChat() {
          panel.style.display = "flex";
          panel.style.flexDirection = "column";
          overlay.style.display = "block";
          trigger.style.transform = "scale(0)";
          trigger.style.opacity = "0";

          setTimeout(() => {
            panel.style.opacity = "1";
            panel.style.transform = "scale(1)";
            overlay.style.opacity = "1";
          }, 10);

          setTimeout(() => {
            const firstInput = panel.querySelector("textarea, input[type=\\"text\\"]");
            if (firstInput) firstInput.focus();
          }, 300);
        }

        trigger.addEventListener("click", openChat);

        trigger.addEventListener("keydown", function(e) {
          if (e.key === "Enter" || e.key === " ") {
            e.preventDefault();
            openChat();
          }
        });

        const closeBtn = panel.querySelector(".floating-chat-close");
        if (closeBtn) {
          closeBtn.addEventListener("click", closeChat);
        }

        const maximizeBtn = panel.querySelector(".floating-chat-maximize");
        if (maximizeBtn) {
          maximizeBtn.addEventListener("click", function() {
            const isMaximized = panel.getAttribute("data-maximized") === "true";

            if (isMaximized) {
              panel.setAttribute("data-maximized", "false");
              maximizeBtn.innerHTML = \'<i class="fa fa-expand-arrows-alt"></i>\';
            } else {
              panel.setAttribute("data-maximized", "true");
              maximizeBtn.innerHTML = \'<i class="fa fa-compress-arrows-alt"></i>\';
            }
          });
        }

        overlay.addEventListener("click", closeChat);

        document.addEventListener("keydown", function(e) {
          if (e.key === "Escape" && panel.style.display === "flex") {
            closeChat();
          }
        });

        function closeChat() {
          panel.style.opacity = "0";
          panel.style.transform = "scale(0.95)";
          overlay.style.opacity = "0";

          setTimeout(() => {
            panel.style.display = "none";
            overlay.style.display = "none";
            trigger.style.transform = "scale(1)";
            trigger.style.opacity = "1";
            trigger.focus();
          }, 200);
        }

        // Handle suggested prompt clicks
        const promptContainer = panel.querySelector(".suggested-prompts");
        if (promptContainer) {
          promptContainer.addEventListener("click", function(e) {
            const chip = e.target.closest(".suggested-prompt-chip");
            if (chip) {
              const promptText = chip.innerText;
              const textArea = panel.querySelector("textarea, input[type=\\"text\\"]");
              if (textArea) {
                textArea.value = promptText;
                textArea.dispatchEvent(new Event("input", { bubbles: true }));
                textArea.focus();
              }
            }
          });
        }
      }

      if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", initFloatingChat);
      } else {
        initFloatingChat();
      }
    })();
  ',
    trigger_id,
    panel_id,
    overlay_id
  )))

  # Inline CSS - Intentional Minimalism (floating-specific + shared)

  # shared_css removed in favor of floating_chat.css

  shiny::tagList(
    htmltools::htmlDependency(
      name = "chatbotr-core",
      version = "0.1.0",
      src = c(file = "www"),
      package = "chatbotr",
      stylesheet = "floating_chat.css"
    ),
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
#' @param client Chat client object (from ellmer)
#' @param ... Additional arguments passed to chat_server_fun
#'
#' @return Returns the result of the chat server function
#'
#' @export
floating_chat_server <- function(
  id,
  client,
  ...
) {
  shiny::moduleServer(id, function(input, output, session) {
    shinychat::chat_mod_server("chat", client, ...)
  })
}
