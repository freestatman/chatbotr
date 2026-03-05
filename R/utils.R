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
  border_color = NULL,
  bg_color = NULL
) {
  if (is.null(prompts) || length(prompts) == 0) {
    return(NULL)
  }

  # Theme-specific variables if provided (for backward compatibility or specific overrides)
  style <- if (!is.null(border_color) || !is.null(bg_color)) {
    paste0(
      if (!is.null(border_color)) {
        paste0("border-top-color: ", border_color, "; ")
      },
      if (!is.null(bg_color)) paste0("background-color: ", bg_color, "; ")
    )
  } else {
    NULL
  }

  shiny::tags$div(
    class = "suggested-prompts",
    style = style,
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
#' @keywords internal
chat_shared_css <- function(include_dark_theme = FALSE) {
  NULL
}

