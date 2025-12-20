#' API Settings UI Module
#'
#' @description
#' Creates a UI for configuring API keys and selecting LLM providers and models.
#' Supports multiple providers (GitHub Models, OpenAI, Anthropic, Google Gemini, etc.)
#' with secure key input and model selection.
#'
#' @param id Namespace ID for the module
#' @param default_provider Default provider to show (default: "github")
#' @param show_advanced Show advanced settings like temperature, max_tokens (default: FALSE)
#' @param inline Display settings inline vs in a modal (default: FALSE)
#'
#' @return A Shiny UI element containing the settings interface
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(shiny)
#' ui <- fluidPage(
#'   api_settings_ui("settings")
#' )
#' }
api_settings_ui <- function(
  id,
  default_provider = "github",
  show_advanced = FALSE,
  inline = FALSE
) {
  ns <- shiny::NS(id)

  settings_content <- shiny::tagList(
    shiny::selectInput(
      inputId = ns("provider"),
      label = "LLM Provider",
      choices = c(
        "GitHub Models" = "github",
        "OpenAI" = "openai",
        "Anthropic (Claude)" = "anthropic",
        "Google Gemini" = "google",
        "Azure OpenAI" = "azure",
        "Ollama (Local)" = "ollama"
      ),
      selected = default_provider
    ),

    shiny::conditionalPanel(
      condition = sprintf("input['%s'] != 'ollama'", ns("provider")),
      ns = ns,
      shiny::passwordInput(
        inputId = ns("api_key"),
        label = shiny::tagList(
          "API Key / Token",
          shiny::tags$small(
            class = "text-muted ms-2",
            "(securely stored in session)"
          )
        ),
        placeholder = "Enter your API key or token"
      )
    ),

    shiny::conditionalPanel(
      condition = sprintf("input['%s'] == 'azure'", ns("provider")),
      ns = ns,
      shiny::textInput(
        inputId = ns("azure_endpoint"),
        label = "Azure Endpoint",
        placeholder = "https://your-resource.openai.azure.com"
      )
    ),

    shiny::conditionalPanel(
      condition = sprintf("input['%s'] == 'ollama'", ns("provider")),
      ns = ns,
      shiny::textInput(
        inputId = ns("ollama_host"),
        label = "Ollama Host",
        value = "http://localhost:11434",
        placeholder = "http://localhost:11434"
      )
    ),

    shiny::uiOutput(ns("model_selector")),

    shiny::tags$div(
      class = "d-flex align-items-center gap-2 mb-2",
      shiny::actionButton(
        inputId = ns("refresh_models"),
        label = "Refresh",
        class = "btn btn-sm btn-outline-secondary",
        icon = shiny::icon("sync"),
        style = "font-size: 0.8rem;"
      ),
      shiny::uiOutput(ns("models_status"))
    ),

    if (show_advanced) {
      shiny::tagList(
        shiny::hr(),
        shiny::tags$h6(
          style = "font-weight: 500; font-size: 0.875rem;",
          "Advanced Settings"
        ),
        shiny::sliderInput(
          inputId = ns("temperature"),
          label = "Temperature",
          min = 0,
          max = 2,
          value = 0.7,
          step = 0.1
        ),
        shiny::numericInput(
          inputId = ns("max_tokens"),
          label = "Max Tokens",
          value = 1000,
          min = 1,
          max = 100000
        )
      )
    },

    shiny::tags$div(
      class = "mt-3 d-flex gap-2",
      shiny::actionButton(
        inputId = ns("save_settings"),
        label = "Save",
        class = "btn btn-dark",
        icon = shiny::icon("check")
      ),
      shiny::actionButton(
        inputId = ns("test_connection"),
        label = "Test",
        class = "btn btn-outline-secondary",
        icon = shiny::icon("plug")
      )
    ),

    shiny::uiOutput(ns("connection_status"))
  )

  if (inline) {
    shiny::tags$div(
      class = "api-settings-inline p-3 border rounded",
      settings_content
    )
  } else {
    settings_content
  }
}

#' API Settings Server Module
#'
#' @description
#' Server logic for API settings configuration. Handles provider selection,
#' API key validation, model selection, and client creation.
#'
#' @param id Namespace ID matching the UI module
#' @param default_system_prompt Default system prompt for the LLM (optional)
#'
#' @return A reactive list containing:
#'   - client: Configured ellmer client (reactive)
#'   - provider: Selected provider (reactive)
#'   - model: Selected model (reactive)
#'   - is_configured: Whether settings are valid (reactive)
#'
#' @export
#'
#' @examples
#' \dontrun{
#' server <- function(input, output, session) {
#'   settings <- api_settings_server("settings")
#'
#'   # Use the configured client
#'   observe({
#'     if (settings$is_configured()) {
#'       client <- settings$client()
#'       # Use client with shinychat
#'     }
#'   })
#' }
#' }
api_settings_server <- function(id, default_system_prompt = NULL) {
  shiny::moduleServer(id, function(input, output, session) {
    # Reactive values to store configuration
    config <- shiny::reactiveValues(
      client = NULL,
      provider = NULL,
      model = NULL,
      api_key = NULL,
      is_valid = FALSE,
      test_status = NULL,
      available_models = NULL,
      models_loading = FALSE
    )

    # Fetch available models from provider API
    fetch_models <- function(provider, api_key = NULL) {
      tryCatch(
        {
          # Set API key temporarily if provided
          if (!is.null(api_key) && nchar(api_key) > 0) {
            models <- switch(
              provider,
              "github" = {
                old_key <- Sys.getenv("GITHUB_TOKEN")
                on.exit(Sys.setenv(GITHUB_TOKEN = old_key))
                Sys.setenv(GITHUB_TOKEN = api_key)
                ellmer::models_github()
              },
              "openai" = {
                old_key <- Sys.getenv("OPENAI_API_KEY")
                on.exit(Sys.setenv(OPENAI_API_KEY = old_key))
                Sys.setenv(OPENAI_API_KEY = api_key)
                ellmer::models_openai()
              },
              "anthropic" = {
                old_key <- Sys.getenv("ANTHROPIC_API_KEY")
                on.exit(Sys.setenv(ANTHROPIC_API_KEY = old_key))
                Sys.setenv(ANTHROPIC_API_KEY = api_key)
                ellmer::models_anthropic()
              },
              "google" = {
                old_key <- Sys.getenv("GOOGLE_API_KEY")
                on.exit(Sys.setenv(GOOGLE_API_KEY = old_key))
                Sys.setenv(GOOGLE_API_KEY = api_key)
                ellmer::models_google_gemini()
              },
              "ollama" = {
                host <- input$ollama_host %||% "http://localhost:11434"
                ellmer::models_ollama(host = host)
              },
              NULL
            )

            # Convert to named list for selectInput
            if (!is.null(models) && length(models) > 0) {
              if (is.data.frame(models)) {
                # If it's a data frame with model IDs
                model_ids <- models$id
                names(model_ids) <- models$id
                return(as.list(model_ids))
              } else if (is.character(models)) {
                # If it's a character vector
                names(models) <- models
                return(as.list(models))
              }
            }
          }

          NULL
        },
        error = function(e) {
          warning("Failed to fetch models: ", e$message)
          NULL
        }
      )
    }

    # Default/fallback model choices
    get_default_models <- function(provider) {
      switch(
        provider,
        "github" = list(
          "GPT-4o" = "gpt-4o",
          "GPT-4o Mini" = "gpt-4o-mini",
          "GPT-4 Turbo" = "gpt-4-turbo",
          "o1 Preview" = "o1-preview",
          "o1 Mini" = "o1-mini",
          "Phi-3.5" = "phi-3.5",
          "Llama 3.1 (405B)" = "llama-3.1-405b",
          "Llama 3.1 (70B)" = "llama-3.1-70b",
          "Mistral Large" = "mistral-large"
        ),
        "openai" = list(
          "GPT-4o" = "gpt-4o",
          "GPT-4o Mini" = "gpt-4o-mini",
          "GPT-4 Turbo" = "gpt-4-turbo",
          "GPT-4" = "gpt-4",
          "GPT-3.5 Turbo" = "gpt-3.5-turbo",
          "o1 Preview" = "o1-preview",
          "o1 Mini" = "o1-mini"
        ),
        "anthropic" = list(
          "Claude 3.5 Sonnet" = "claude-3-5-sonnet-20241022",
          "Claude 3 Opus" = "claude-3-opus-20240229",
          "Claude 3 Sonnet" = "claude-3-sonnet-20240229",
          "Claude 3 Haiku" = "claude-3-haiku-20240307"
        ),
        "google" = list(
          "Gemini 1.5 Pro" = "gemini-1.5-pro",
          "Gemini 1.5 Flash" = "gemini-1.5-flash",
          "Gemini 1.0 Pro" = "gemini-1.0-pro"
        ),
        "azure" = list(
          "GPT-4o" = "gpt-4o",
          "GPT-4o Mini" = "gpt-4o-mini",
          "GPT-4 Turbo" = "gpt-4-turbo",
          "GPT-4" = "gpt-4",
          "GPT-3.5 Turbo" = "gpt-3.5-turbo"
        ),
        "ollama" = list(
          "Llama 3.2" = "llama3.2",
          "Llama 3.1" = "llama3.1",
          "Llama 3" = "llama3",
          "Mistral" = "mistral",
          "Mixtral" = "mixtral",
          "Phi-3" = "phi3",
          "Gemma 2" = "gemma2",
          "CodeLlama" = "codellama"
        ),
        list("Default Model" = "default")
      )
    }

    # Model choices - try dynamic first, fallback to defaults
    model_choices <- shiny::reactive({
      # Use cached models if available
      if (!is.null(config$available_models)) {
        return(config$available_models)
      }

      # Otherwise use defaults
      get_default_models(input$provider)
    })

    # Render model selector
    output$model_selector <- shiny::renderUI({
      ns <- session$ns
      choices <- model_choices()

      shiny::selectInput(
        inputId = ns("model"),
        label = shiny::tagList(
          "Model",
          shiny::tags$small(
            class = "text-muted ms-2",
            sprintf("(%s)", input$provider)
          )
        ),
        choices = choices,
        selected = choices[[1]]
      )
    })

    # Render models status
    output$models_status <- shiny::renderUI({
      if (config$models_loading) {
        shiny::tags$small(
          class = "text-muted",
          shiny::icon("spinner", class = "fa-spin"),
          " Loading models..."
        )
      } else if (!is.null(config$available_models)) {
        shiny::tags$small(
          class = "text-success",
          shiny::icon("check"),
          sprintf(" %d models loaded", length(config$available_models))
        )
      } else {
        shiny::tags$small(
          class = "text-muted",
          "Using default models"
        )
      }
    })

    # Refresh models when button is clicked
    shiny::observeEvent(input$refresh_models, {
      provider <- input$provider

      # Check if we need API key
      if (
        provider != "ollama" &&
          (is.null(input$api_key) || nchar(input$api_key) == 0)
      ) {
        shiny::showNotification(
          "Please enter your API key first",
          type = "warning",
          duration = 3
        )
        return()
      }

      config$models_loading <- TRUE

      # Fetch models
      models <- fetch_models(provider, input$api_key)

      config$models_loading <- FALSE

      if (!is.null(models) && length(models) > 0) {
        config$available_models <- models
        shiny::showNotification(
          sprintf("Loaded %d models from %s", length(models), provider),
          type = "message",
          duration = 3
        )
      } else {
        config$available_models <- NULL
        shiny::showNotification(
          "Failed to load models. Using defaults.",
          type = "warning",
          duration = 3
        )
      }
    })

    # Auto-refresh models when provider changes
    shiny::observe({
      # Reset available models when provider changes
      config$available_models <- NULL
    }) |>
      shiny::bindEvent(input$provider)

    # Render connection status
    output$connection_status <- shiny::renderUI({
      if (is.null(config$test_status)) {
        return(NULL)
      }

      alert_class <- if (config$test_status$success) {
        "alert-success"
      } else {
        "alert-danger"
      }

      shiny::tags$div(
        class = paste("alert mt-3", alert_class),
        role = "alert",
        shiny::tags$strong(
          if (config$test_status$success) "Success! " else "Error: "
        ),
        config$test_status$message
      )
    })

    # Create client based on settings
    create_client <- function(api_key = NULL, model = NULL) {
      tryCatch(
        {
          provider <- input$provider
          selected_model <- model %||% input$model
          key <- api_key %||% input$api_key

          # Build common args (only include non-NULL values)
          common_args <- list()

          # Add system prompt if provided (parameter is 'system' not 'system_prompt')
          if (!is.null(default_system_prompt)) {
            common_args$system <- default_system_prompt
          }

          # Add model if provided
          if (!is.null(selected_model) && selected_model != "default") {
            common_args$model <- selected_model
          }

          # Create client based on provider
          client <- switch(
            provider,
            "github" = {
              if (!is.null(key) && nchar(key) > 0) {
                # Temporarily set environment variable for this request
                old_token <- Sys.getenv("GITHUB_TOKEN")
                on.exit(Sys.setenv(GITHUB_TOKEN = old_token))
                Sys.setenv(GITHUB_TOKEN = key)
              }
              do.call(ellmer::chat_github, common_args)
            },
            "openai" = {
              if (!is.null(key) && nchar(key) > 0) {
                old_key <- Sys.getenv("OPENAI_API_KEY")
                on.exit(Sys.setenv(OPENAI_API_KEY = old_key))
                Sys.setenv(OPENAI_API_KEY = key)
              }
              do.call(ellmer::chat_openai, common_args)
            },
            "anthropic" = {
              if (!is.null(key) && nchar(key) > 0) {
                old_key <- Sys.getenv("ANTHROPIC_API_KEY")
                on.exit(Sys.setenv(ANTHROPIC_API_KEY = old_key))
                Sys.setenv(ANTHROPIC_API_KEY = key)
              }
              do.call(ellmer::chat_claude, common_args)
            },
            "google" = {
              if (!is.null(key) && nchar(key) > 0) {
                old_key <- Sys.getenv("GOOGLE_API_KEY")
                on.exit(Sys.setenv(GOOGLE_API_KEY = old_key))
                Sys.setenv(GOOGLE_API_KEY = key)
              }
              do.call(ellmer::chat_google_gemini, common_args)
            },
            "azure" = {
              if (!is.null(key) && nchar(key) > 0) {
                old_key <- Sys.getenv("AZURE_OPENAI_API_KEY")
                on.exit(Sys.setenv(AZURE_OPENAI_API_KEY = old_key))
                Sys.setenv(AZURE_OPENAI_API_KEY = key)
              }
              if (
                !is.null(input$azure_endpoint) &&
                  nchar(input$azure_endpoint) > 0
              ) {
                old_endpoint <- Sys.getenv("AZURE_OPENAI_ENDPOINT")
                on.exit(
                  Sys.setenv(AZURE_OPENAI_ENDPOINT = old_endpoint),
                  add = TRUE
                )
                Sys.setenv(AZURE_OPENAI_ENDPOINT = input$azure_endpoint)
              }
              do.call(ellmer::chat_azure_openai, common_args)
            },
            "ollama" = {
              ollama_args <- common_args
              if (!is.null(input$ollama_host) && nchar(input$ollama_host) > 0) {
                ollama_args$host <- input$ollama_host
              }
              do.call(ellmer::chat_ollama, ollama_args)
            },
            stop("Unknown provider: ", provider)
          )

          client
        },
        error = function(e) {
          warning("Failed to create client: ", e$message)
          NULL
        }
      )
    }

    # Save settings
    shiny::observeEvent(input$save_settings, {
      # Validate inputs
      if (input$provider != "ollama") {
        if (is.null(input$api_key) || nchar(input$api_key) == 0) {
          shiny::showNotification(
            "Please enter an API key",
            type = "error"
          )
          return()
        }
      }

      if (input$provider == "azure") {
        if (is.null(input$azure_endpoint) || nchar(input$azure_endpoint) == 0) {
          shiny::showNotification(
            "Please enter Azure endpoint",
            type = "error"
          )
          return()
        }
      }

      # Create client
      client <- create_client()

      if (!is.null(client)) {
        config$client <- client
        config$provider <- input$provider
        config$model <- input$model
        config$api_key <- input$api_key
        config$is_valid <- TRUE

        shiny::showNotification(
          "Settings saved successfully!",
          type = "message"
        )

        # Close modal if in one
        session$sendCustomMessage("closeSettingsModal", list())
      } else {
        shiny::showNotification(
          "Failed to create client. Please check your settings.",
          type = "error"
        )
      }
    })

    # Test connection
    shiny::observeEvent(input$test_connection, {
      if (input$provider != "ollama") {
        if (is.null(input$api_key) || nchar(input$api_key) == 0) {
          config$test_status <- list(
            success = FALSE,
            message = "Please enter an API key first"
          )
          return()
        }
      }

      # Show loading notification
      loading_id <- shiny::showNotification(
        "Testing connection...",
        duration = NULL,
        type = "message"
      )

      tryCatch(
        {
          # Create a test client
          test_client <- create_client()

          if (is.null(test_client)) {
            config$test_status <- list(
              success = FALSE,
              message = "Failed to create client"
            )
            return()
          }

          # Try a simple test query
          response <- test_client$chat("Say 'hello' in one word")

          if (!is.null(response)) {
            config$test_status <- list(
              success = TRUE,
              message = sprintf(
                "Connection successful! Provider: %s, Model: %s",
                input$provider,
                input$model
              )
            )
          } else {
            config$test_status <- list(
              success = FALSE,
              message = "No response from API"
            )
          }
        },
        error = function(e) {
          config$test_status <- list(
            success = FALSE,
            message = paste("Connection failed:", e$message)
          )
        },
        finally = {
          shiny::removeNotification(loading_id)
        }
      )
    })

    # Return reactive values
    list(
      client = shiny::reactive(config$client),
      provider = shiny::reactive(config$provider),
      model = shiny::reactive(config$model),
      is_configured = shiny::reactive(config$is_valid)
    )
  })
}
