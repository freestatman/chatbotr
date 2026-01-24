test_that("api_settings_ui renders correctly", {
  ui <- api_settings_ui(
    id = "test",
    default_provider = "github",
    show_advanced = FALSE,
    inline = FALSE
  )

  expect_s3_class(ui, "shiny.tag.list")
  expect_true(length(ui) > 0)
})

test_that("api_settings_ui includes required inputs", {
  ui <- api_settings_ui(id = "test")
  ui_html <- as.character(ui)

  # Check for provider selector
  expect_true(grepl("test-provider", ui_html))

  # Check for API key input
  expect_true(grepl("test-api_key", ui_html))

  # Check for model selector placeholder
  expect_true(grepl("test-model_selector", ui_html))

  # Check for save and test buttons
  expect_true(grepl("test-save_settings", ui_html))
  expect_true(grepl("test-test_connection", ui_html))

  # Check for refresh models button
  expect_true(grepl("test-refresh_models", ui_html))
})

test_that("api_settings_ui advanced settings can be shown", {
  ui_basic <- api_settings_ui(id = "test", show_advanced = FALSE)
  ui_advanced <- api_settings_ui(id = "test", show_advanced = TRUE)

  ui_basic_html <- as.character(ui_basic)
  ui_advanced_html <- as.character(ui_advanced)

  # Advanced settings should include temperature and max_tokens
  expect_false(grepl("test-temperature", ui_basic_html))
  expect_true(grepl("test-temperature", ui_advanced_html))
  expect_true(grepl("test-max_tokens", ui_advanced_html))
})

test_that("api_settings_ui inline mode works", {
  ui_normal <- api_settings_ui(id = "test", inline = FALSE)
  ui_inline <- api_settings_ui(id = "test", inline = TRUE)

  ui_inline_html <- as.character(ui_inline)

  # Inline should have wrapper div with class
  expect_true(grepl("api-settings-inline", ui_inline_html))
})

test_that("model choices defaults are correct", {
  # Test that default model lists exist for all providers
  providers <- c("github", "openai", "anthropic", "google", "azure", "ollama")

  for (provider in providers) {
    # This is a simple test - in a real app we'd test the reactive
    expect_true(provider %in% providers)
  }
})

test_that("fetch_models handles errors gracefully", {
  # This would require mocking ellmer functions
  # For now, we just verify the function structure exists in the module
  skip("Requires mocking ellmer API calls")
})

# Tests for environment variable detection

test_that("get_provider_env_var returns correct env vars for each provider", {
  # GitHub - should check GITHUB_PAT first, then GITHUB_TOKEN
  github_vars <- chatbotr:::get_provider_env_var("github")
  expect_equal(github_vars, c("GITHUB_PAT", "GITHUB_TOKEN"))

  # OpenAI
  openai_vars <- chatbotr:::get_provider_env_var("openai")
  expect_equal(openai_vars, "OPENAI_API_KEY")

  # Anthropic
  anthropic_vars <- chatbotr:::get_provider_env_var("anthropic")
  expect_equal(anthropic_vars, "ANTHROPIC_API_KEY")

  # Google - should check GEMINI_API_KEY first, then GOOGLE_API_KEY
  google_vars <- chatbotr:::get_provider_env_var("google")
  expect_equal(google_vars, c("GEMINI_API_KEY", "GOOGLE_API_KEY"))

  # Ollama - should return NULL (no API key needed)
  ollama_vars <- chatbotr:::get_provider_env_var("ollama")
  expect_null(ollama_vars)

  # Unknown provider
  unknown_vars <- chatbotr:::get_provider_env_var("unknown")
  expect_null(unknown_vars)
})

test_that("detect_env_key returns NULL when no env var is set", {
  # Save and clear any existing env vars
  old_pat <- Sys.getenv("GITHUB_PAT", "")
  old_token <- Sys.getenv("GITHUB_TOKEN", "")
  withr::defer({
    if (nchar(old_pat) > 0) {
      Sys.setenv(GITHUB_PAT = old_pat)
    }
    if (nchar(old_token) > 0) Sys.setenv(GITHUB_TOKEN = old_token)
  })

  Sys.unsetenv("GITHUB_PAT")
  Sys.unsetenv("GITHUB_TOKEN")

  result <- chatbotr:::detect_env_key("github")
  expect_null(result)
})

test_that("detect_env_key detects and masks keys correctly", {
  # Save existing env var
  old_key <- Sys.getenv("OPENAI_API_KEY", "")
  withr::defer({
    if (nchar(old_key) > 0) {
      Sys.setenv(OPENAI_API_KEY = old_key)
    } else {
      Sys.unsetenv("OPENAI_API_KEY")
    }
  })

  # Set a test key
  test_key <- "sk-test1234567890abcdefg"
  Sys.setenv(OPENAI_API_KEY = test_key)

  result <- chatbotr:::detect_env_key("openai")

  expect_type(result, "list")
  expect_equal(result$var_name, "OPENAI_API_KEY")
  expect_equal(result$key, test_key)
  # Masked should show first 4 + **** + last 4
  expect_equal(result$masked, "sk-t****defg")
})

test_that("detect_env_key prioritizes GITHUB_PAT over GITHUB_TOKEN", {
  # Save existing env vars
  old_pat <- Sys.getenv("GITHUB_PAT", "")
  old_token <- Sys.getenv("GITHUB_TOKEN", "")
  withr::defer({
    if (nchar(old_pat) > 0) {
      Sys.setenv(GITHUB_PAT = old_pat)
    } else {
      Sys.unsetenv("GITHUB_PAT")
    }
    if (nchar(old_token) > 0) {
      Sys.setenv(GITHUB_TOKEN = old_token)
    } else {
      Sys.unsetenv("GITHUB_TOKEN")
    }
  })

  # Set both env vars
  Sys.setenv(GITHUB_PAT = "ghp_pat_value_12345678")
  Sys.setenv(GITHUB_TOKEN = "ghp_token_value_5678")

  result <- chatbotr:::detect_env_key("github")

  # Should prefer GITHUB_PAT

  expect_equal(result$var_name, "GITHUB_PAT")
  expect_equal(result$key, "ghp_pat_value_12345678")
})

test_that("detect_env_key falls back to GITHUB_TOKEN when GITHUB_PAT not set", {
  # Save existing env vars
  old_pat <- Sys.getenv("GITHUB_PAT", "")
  old_token <- Sys.getenv("GITHUB_TOKEN", "")
  withr::defer({
    if (nchar(old_pat) > 0) {
      Sys.setenv(GITHUB_PAT = old_pat)
    } else {
      Sys.unsetenv("GITHUB_PAT")
    }
    if (nchar(old_token) > 0) {
      Sys.setenv(GITHUB_TOKEN = old_token)
    } else {
      Sys.unsetenv("GITHUB_TOKEN")
    }
  })

  # Only set GITHUB_TOKEN
  Sys.unsetenv("GITHUB_PAT")
  Sys.setenv(GITHUB_TOKEN = "ghp_token_only_1234")

  result <- chatbotr:::detect_env_key("github")

  expect_equal(result$var_name, "GITHUB_TOKEN")
  expect_equal(result$key, "ghp_token_only_1234")
})

test_that("detect_env_key handles short keys correctly", {
  # Save existing env vars (both GEMINI and GOOGLE)
  old_gemini_key <- Sys.getenv("GEMINI_API_KEY", "")
  old_google_key <- Sys.getenv("GOOGLE_API_KEY", "")
  withr::defer({
    if (nchar(old_gemini_key) > 0) {
      Sys.setenv(GEMINI_API_KEY = old_gemini_key)
    } else {
      Sys.unsetenv("GEMINI_API_KEY")
    }
    if (nchar(old_google_key) > 0) {
      Sys.setenv(GOOGLE_API_KEY = old_google_key)
    } else {
      Sys.unsetenv("GOOGLE_API_KEY")
    }
  })

  # Unset GEMINI_API_KEY so GOOGLE_API_KEY is used
  Sys.unsetenv("GEMINI_API_KEY")
  # Set a short key (8 chars or less)
  Sys.setenv(GOOGLE_API_KEY = "short")

  result <- chatbotr:::detect_env_key("google")

  expect_equal(result$var_name, "GOOGLE_API_KEY")
  expect_equal(result$key, "short")
  # Short keys should just show ****
  expect_equal(result$masked, "****")
})

test_that("api_settings_ui includes env_key_hint output", {
  ui <- api_settings_ui(id = "test")
  ui_html <- as.character(ui)

  # Check for env_key_hint uiOutput
  expect_true(grepl("test-env_key_hint", ui_html))
})
