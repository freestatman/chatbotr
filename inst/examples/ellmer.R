# install.packages("ellmer")
# pak::pkg_install("tidyverse/ellmer")
pak::pkg_remove("ellmer")
pak::pkg_install("D-M4rk/ellmer")
# y
#
library(ellmer)
client = ellmer::chat_github(
  system_prompt = "You are a helpful assistant for this demo app."
)
client$chat("hi")
client$chat("what's the date today?")
client = ellmer::chat_google_gemini(
  system_prompt = "You are a helpful assistant for this demo app."
)
client$chat("hi")

models_github()

models_github(
  base_url = "https://models.github.ai/",
  api_key = NULL,
  credentials = NULL
)

client$chat("hi")

# test if my github token is valid
token_is_valid <- function(token) {
  # Check if token is provided
  if (missing(token) || !nzchar(token)) {
    stop("GitHub token must be provided.")
  }

  url <- "https://api.github.com/user"
  res <- httr::GET(
    url,
    httr::add_headers(Authorization = paste("token", token))
  )

  httr::status_code(res) == 200
}

token_is_valid(Sys.getenv("GITHUB_PAT"))
