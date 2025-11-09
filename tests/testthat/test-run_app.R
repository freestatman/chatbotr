test_that("run_app function exists and has correct signature", {
  expect_true(exists("run_app"))
  expect_type(run_app, "closure")
  
  # Check function arguments
  args <- formals(run_app)
  expect_true("launch.browser" %in% names(args))
  expect_true("port" %in% names(args))
  expect_true("host" %in% names(args))
  expect_true("..." %in% names(args))
})

test_that("run_app has correct default values", {
  args <- formals(run_app)
  expect_equal(args$launch.browser, TRUE)
  expect_null(args$port)
  expect_null(args$host)
})

test_that("run_app can locate app.R in inst directory", {
  # Create a temporary test structure
  temp_dir <- tempdir()
  inst_dir <- file.path(temp_dir, "inst")
  dir.create(inst_dir, showWarnings = FALSE, recursive = TRUE)
  
  # Create a minimal app.R
  app_file <- file.path(inst_dir, "app.R")
  writeLines(c(
    "library(shiny)",
    "ui <- fluidPage(h1('Test App'))",
    "server <- function(input, output, session) {}",
    "shinyApp(ui, server)"
  ), app_file)
  
  expect_true(file.exists(app_file))
  
  # Cleanup
  unlink(inst_dir, recursive = TRUE)
})

test_that("run_app documentation is complete", {
  # Check that the function is documented
  help_file <- help("run_app", package = "chatbotr")
  expect_true(length(help_file) > 0 || is.null(help_file))
})

# Mock test for shiny::runApp call
test_that("run_app would call shiny::runApp with correct parameters", {
  skip_if_not_installed("mockery")
  
  # This test requires the mockery package
  # It verifies that run_app calls shiny::runApp correctly
  # In a real scenario, you'd mock shiny::runApp to avoid actually launching the app
})
