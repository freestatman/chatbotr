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
#' @param enable_minimize Enable minimize functionality (default: TRUE)
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
  enable_minimize = TRUE,
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

  # Trigger button positioning - Intentional Minimalism
  trigger_style <- paste0(
    "position: fixed; ",
    "z-index: 1046; ",
    vertical,
    ": ",
    panel_offset,
    "px; ",
    horizontal,
    ": ",
    panel_offset,
    "px; ",
    "width: ",
    trigger_size,
    "px; ",
    "height: ",
    trigger_size,
    "px; ",
    "border-radius: 50%; ",
    "display: flex; ",
    "align-items: center; ",
    "justify-content: center; ",
    "cursor: pointer; ",
    "transition: all 0.2s ease; ",
    "box-shadow: 0 4px 12px rgb(0 0 0 / 0.15); ",
    "user-select: none; "
  )

  # Panel positioning - Clean, minimal styling
  bg_color <- if (theme == "dark") "#18181b" else "#ffffff"
  border_color <- if (theme == "dark") "#27272a" else "#e5e5e5"
  panel_style <- paste0(
    "position: fixed; ",
    "z-index: 1050; ",
    vertical,
    ": ",
    panel_offset,
    "px; ",
    horizontal,
    ": ",
    panel_offset,
    "px; ",
    "width: ",
    panel_width_css,
    "; ",
    "height: ",
    panel_height_css,
    "; ",
    "display: none; ",
    "background: ",
    bg_color,
    "; ",
    "border: 1px solid ",
    border_color,
    "; ",
    "border-radius: 12px; ",
    "overflow: hidden; ",
    "transition: all 0.2s ease; ",
    "box-shadow: 0 8px 30px rgb(0 0 0 / 0.12); "
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
    "transition: opacity 0.2s ease; "
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
    style = trigger_style,
    `data-chat-id` = panel_id,
    `role` = "button",
    `aria-label` = "Open chat assistant",
    `tabindex` = "0",
    shiny::tags$i(
      class = paste("fa fa-", trigger_icon, sep = ""),
      style = "font-size: 1.5rem;",
      `aria-hidden` = "true"
    )
  )

  # Chat panel header - Minimal styling
  minimize_btn <- if (enable_minimize) {
    shiny::tags$button(
      class = "btn btn-sm btn-ghost floating-chat-minimize",
      type = "button",
      `aria-label` = "Minimize chat",
      shiny::icon("minus")
    )
  } else {
    NULL
  }

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
    class = "floating-chat-header",
    style = paste0(
      "padding: 0.875rem 1rem; ",
      "border-bottom: 1px solid ",
      border_color,
      "; ",
      "display: flex; ",
      "align-items: center; ",
      "justify-content: space-between; ",
      "background: ",
      bg_color,
      "; ",
      "min-height: 3.5rem; "
    ),
    shiny::tags$h5(
      style = "margin: 0; font-weight: 500; font-size: 0.9rem;",
      title
    ),
    shiny::tags$div(
      class = "d-flex gap-1 align-items-center",
      header_actions,
      maximize_btn,
      minimize_btn,
      shiny::tags$button(
        class = "btn btn-sm btn-ghost floating-chat-close",
        type = "button",
        `aria-label` = "Close chat",
        shiny::icon("times")
      )
    )
  )

  # Suggested Prompts Area
  prompts_ui <- chat_prompts_ui(suggested_prompts, border_color, bg_color)

  # Chat UI content
  chat_ui <- do.call(
    shinychat::chat_mod_ui,
    c(list(id = ns("chat")), chat_ui_args)
  )

  # Chat panel body
  body <- shiny::tags$div(
    class = "floating-chat-body",
    style = paste0(
      "height: calc(100% - 3.5rem); ",
      "overflow: hidden; ",
      "display: flex; ",
      "flex-direction: column; ",
      "background: ",
      bg_color,
      "; "
    ),
    chat_ui,
    prompts_ui
  )

  # Complete chat panel with accessibility attributes
  panel <- shiny::tags$div(
    id = panel_id,
    class = paste("floating-chat-panel", theme_class),
    style = panel_style,
    `data-minimized` = "false",
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
    class = "floating-chat-overlay",
    style = overlay_style
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

        const minimizeBtn = panel.querySelector(".floating-chat-minimize");
        if (minimizeBtn) {
          minimizeBtn.addEventListener("click", function() {
            const isMinimized = panel.getAttribute("data-minimized") === "true";
            if (isMinimized) {
              panel.style.height = "%s";
              panel.setAttribute("data-minimized", "false");
              minimizeBtn.innerHTML = \'<i class="fa fa-minus"></i>\';
            } else {
              panel.style.height = "3.5rem";
              panel.setAttribute("data-minimized", "true");
              minimizeBtn.innerHTML = \'<i class="fa fa-chevron-up"></i>\';
            }
          });
        }

        const maximizeBtn = panel.querySelector(".floating-chat-maximize");
        if (maximizeBtn) {
          maximizeBtn.addEventListener("click", function() {
            const isMaximized = panel.getAttribute("data-maximized") === "true";
            const isMinimized = panel.getAttribute("data-minimized") === "true";

            if (isMaximized) {
              const originalWidth = panel.getAttribute("data-original-width");
              const originalHeight = panel.getAttribute("data-original-height");
              const originalPosition = panel.getAttribute("data-original-position");
              const parts = originalPosition.split("-");
              const vert = parts[0];
              const horiz = parts[1];

              panel.style.width = originalWidth;
              panel.style.height = originalHeight;
              panel.style.top = vert === "top" ? "%spx" : "auto";
              panel.style.bottom = vert === "bottom" ? "%spx" : "auto";
              panel.style.left = horiz === "left" ? "%spx" : "auto";
              panel.style.right = horiz === "right" ? "%spx" : "auto";
              panel.style.borderRadius = "12px";

              panel.setAttribute("data-maximized", "false");
              maximizeBtn.innerHTML = \'<i class="fa fa-expand-arrows-alt"></i>\';
            } else {
              if (isMinimized) {
                const originalHeight = panel.getAttribute("data-original-height");
                panel.style.height = originalHeight;
                panel.setAttribute("data-minimized", "false");
                const minBtn = panel.querySelector(".floating-chat-minimize");
                if (minBtn) minBtn.innerHTML = \'<i class="fa fa-minus"></i>\';
              }

              panel.style.top = "0";
              panel.style.bottom = "0";
              panel.style.left = "0";
              panel.style.right = "0";
              panel.style.width = "100vw";
              panel.style.height = "100vh";
              panel.style.borderRadius = "0";

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
    overlay_id,
    panel_height_css,
    panel_offset,
    panel_offset,
    panel_offset,
    panel_offset
  )))

  # Inline CSS - Intentional Minimalism (floating-specific + shared)
  floating_specific_css <- shiny::tags$style(shiny::HTML(
    "
    /* Floating Chat - Intentional Minimalism */

    .floating-chat-light .floating-chat-trigger {
      background: #171717;
      color: #fafafa;
    }
    .floating-chat-light .floating-chat-trigger:hover {
      background: #262626;
      transform: scale(1.05);
    }

    .floating-chat-dark .floating-chat-trigger {
      background: #fafafa;
      color: #171717;
    }
    .floating-chat-dark .floating-chat-trigger:hover {
      background: #e5e5e5;
      transform: scale(1.05);
    }

    .floating-chat-panel {
      opacity: 0;
      transform: scale(0.95);
    }

    .floating-chat-overlay {
      opacity: 0;
    }

    @media (max-width: 768px) {
      .floating-chat-panel {
        width: 100vw !important;
        height: 100vh !important;
        left: 0 !important;
        right: 0 !important;
        top: 0 !important;
        bottom: 0 !important;
        border-radius: 0 !important;
        border: none !important;
      }
    }
  "
  ))

  shared_css <- chat_shared_css(include_dark_theme = TRUE)

  shiny::tagList(
    floating_specific_css,
    shared_css,
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
