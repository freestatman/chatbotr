#' Shared Utilities for chatbotr
#'
#' Internal utility functions used across chat modules.
#' These are not exported and are for internal use only.
#'
#' @name utils
#' @keywords internal
NULL

#' Null coalescing operator
#'
#' @param x Value to check
#' @param y Default value if x is NULL
#' @return x if not NULL, otherwise y
#' @keywords internal
`%||%` <- function(x, y) if (is.null(x)) y else x

#' Format CSS dimension
#'
#' Converts numeric values to pixel strings, passes through string values.
#'
#' @param dim A numeric value (pixels) or string with units (e.g., "30vw")
#' @return A CSS-compatible dimension string
#' @keywords internal
format_dimension <- function(dim) {
  if (is.numeric(dim)) {
    paste0(dim, "px")
  } else {
    dim
  }
}

#' Generate suggested prompts UI
#'
#' Creates the horizontal scrolling chip container for suggested prompts.
#'
#' @param prompts Character vector of prompt strings
#' @param border_color CSS color for the top border (default: "#e5e5e5")
#' @param bg_color CSS color for background (default: "#fff")
#' @return A shiny tags$div or NULL if no prompts
#' @keywords internal
chat_prompts_ui <- function(
  prompts,
  border_color = "#e5e5e5",
  bg_color = "#fff"
) {
  if (is.null(prompts) || length(prompts) == 0) {
    return(NULL)
  }

  shiny::tags$div(
    class = "suggested-prompts",
    style = paste0(
      "padding: 0.5rem 0.75rem; ",
      "overflow-x: auto; ",
      "white-space: nowrap; ",
      "display: flex; ",
      "gap: 0.5rem; ",
      "border-top: 1px solid ",
      border_color,
      "; ",
      "background: ",
      bg_color,
      ";"
    ),
    lapply(prompts, function(prompt) {
      shiny::tags$button(
        class = "suggested-prompt-chip",
        type = "button",
        prompt
      )
    })
  )
}

#' Generate JavaScript for suggested prompt clicks
#'
#' Creates the JS code to handle clicking on prompt chips.
#'
#' @param container_id The DOM ID of the container element
#' @return A shiny tags$script element
#' @keywords internal
chat_prompts_js <- function(container_id) {
  shiny::tags$script(shiny::HTML(sprintf(
    '
    (function() {
      const containerId = "%s";

      function initPromptChips() {
        const container = document.getElementById(containerId);
        if (!container) return;

        const promptContainer = container.querySelector(".suggested-prompts");
        if (promptContainer) {
          promptContainer.addEventListener("click", function(e) {
            const chip = e.target.closest(".suggested-prompt-chip");
            if (chip) {
              const promptText = chip.innerText;
              const textArea = container.querySelector("textarea, input[type=\\"text\\"]");
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
        document.addEventListener("DOMContentLoaded", initPromptChips);
      } else {
        initPromptChips();
      }
    })();
  ',
    container_id
  )))
}

#' Shared CSS for chat components
#'
#' Returns the CSS styles shared between floating and offcanvas chat modules.
#'
#' @param include_dark_theme Whether to include dark theme variants (default: FALSE)
#' @return A shiny tags$style element
#' @keywords internal
chat_shared_css <- function(include_dark_theme = FALSE) {
  base_css <- "
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

    .suggested-prompt-chip {
      display: inline-flex;
      align-items: center;
      padding: 0.375rem 0.75rem;
      border-radius: 9999px;
      border: 1px solid #e5e5e5;
      background: #fafafa;
      color: #525252;
      font-size: 0.75rem;
      cursor: pointer;
      transition: all 0.15s ease;
      white-space: nowrap;
    }
    .suggested-prompt-chip:hover {
      background: #f5f5f5;
      border-color: #d4d4d4;
      color: #171717;
    }

    .suggested-prompts {
      scrollbar-width: none;
      -ms-overflow-style: none;
    }
    .suggested-prompts::-webkit-scrollbar {
      display: none;
    }
  "

  dark_css <- if (include_dark_theme) {
    "
    .floating-chat-dark .btn-ghost:hover {
      background: rgba(255,255,255,0.1);
      color: #fafafa;
    }
    .floating-chat-dark .suggested-prompt-chip {
      border-color: #3f3f46;
      background: #27272a;
      color: #a1a1aa;
    }
    .floating-chat-dark .suggested-prompt-chip:hover {
      background: #3f3f46;
      color: #fafafa;
    }
    "
  } else {
    ""
  }

  shiny::tags$style(shiny::HTML(paste0(base_css, dark_css)))
}
