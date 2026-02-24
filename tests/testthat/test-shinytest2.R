library(shinytest2)

test_that("Floating chat demo app starts correctly", {
  skip_if_not_installed("shinytest2")
  skip_if_not_installed("chromote")
  skip_on_cran()

  app_file <- system.file("examples/floating_chat_demo.R", package = "chatbotr")

  # Check if we are in development or installed
  if (app_file == "") {
    app_file <- testthat::test_path("../../inst/examples/floating_chat_demo.R")
  }

  # Source the app script into a new environment to get the app object
  app_env <- new.env()
  app_obj <- source(app_file, local = app_env)$value

  # Start the app
  app <- AppDriver$new(
    app_obj,
    name = "floating_chat_demo",
    load_timeout = 20000
  )

  # Check that the app initialized by checking an input
  vals <- app$get_values()
  expect_true("clear_chat" %in% names(vals$input))
  app$stop()
})

test_that("BYOK demo app starts correctly", {
  skip_if_not_installed("shinytest2")
  skip_if_not_installed("chromote")
  skip_on_cran()

  app_file <- system.file("examples/byok_floating_chat.R", package = "chatbotr")
  if (app_file == "") {
    app_file <- testthat::test_path("../../inst/examples/byok_floating_chat.R")
  }

  app_env <- new.env()
  app_obj <- source(app_file, local = app_env)$value

  app <- AppDriver$new(
    app_obj,
    name = "byok_floating_chat",
    load_timeout = 20000
  )

  # Check for settings modal trigger
  vals <- app$get_values()
  expect_true("open_settings" %in% names(vals$input))
  app$stop()
})
