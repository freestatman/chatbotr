# chatbotr

<!-- badges: start -->
![Experimental](https://img.shields.io/badge/status-experimental-orange)
![Vibe Coding](https://img.shields.io/badge/vibe-coded-blueviolet)
<!-- badges: end -->

> A floating chatbot for Shiny. Because every other ecosystem has one and R didn't.

Python has chat widgets. JavaScript has chat widgets. R/Shiny had `textInput()` and a prayer.

`chatbotr` adds a floating chat bubble (or slide-out panel) on top of [{shinychat}](https://github.com/posit-dev/shinychat) to any Shiny app, backed by any LLM via [{ellmer}](https://ellmer.tidyverse.org). Bring your own key.

## Installation

```r
pak::pak("freestatman/chatbotr")
```

> [!IMPORTANT]
> Requires `ellmer >= 0.4.0.9000`, to use GitHub API as model provider: [unreleased PR](https://github.com/tidyverse/ellmer/pull/877)
> `pak` also resolves the `shinychat` remote
> (`posit-dev/shinychat`) so you don't have to think about it.

## Quick start

```r
library(shiny); library(bslib); library(chatbotr)

ui <- page_fluid(
  floating_chat_ui("chat")
)
server <- function(input, output, session) {
  floating_chat_server("chat", client = ellmer::chat_github(model = "gpt-5-mini"))
}
shinyApp(ui, server)
```

Chat bubble, bottom-right corner. Click, talk, close. Dashboard unharmed.

## Two flavors

| Style | UI | Server |
|---|---|---|
| Floating bubble | `floating_chat_ui()` | `floating_chat_server()` |
| Slide-out panel | `offcanvas_chat_ui()` | `offcanvas_chat_server()` |

Both accept any `ellmer` client. GitHub Copilot, OpenAI, Anthropic, Gemini — dealer's choice.

## BYOK

Let users supply their own API key at runtime:

```r
ui <- page_fluid(
  api_settings_ui("settings"),
  floating_chat_ui("chat")
)
server <- function(input, output, session) {
  settings <- api_settings_server("settings")
  observe({
    req(settings$is_configured())
    floating_chat_server("chat", client = settings$client())
  })
}
shinyApp(ui, server)
```

Or set `OPENAI_API_KEY` in `.Renviron` and move on with your life.

## Examples

```r
shiny::runApp(system.file("examples/floating_chat_demo.R", package = "chatbotr"))
shiny::runApp(system.file("examples/byok_floating_chat.R", package = "chatbotr"))
shiny::runApp(system.file("examples/offcanvas_chat_demo.R", package = "chatbotr"))
```

Browse the example source on GitHub: [Floating](https://github.com/freestatman/chatbotr/blob/main/inst/examples/floating_chat_demo.R), [BYOK](https://github.com/freestatman/chatbotr/blob/main/inst/examples/byok_floating_chat.R), [Offcanvas](https://github.com/freestatman/chatbotr/blob/main/inst/examples/offcanvas_chat_demo.R).

## Development

```bash
make dev    # format + document + load_all
make test   # unit tests
make check  # R CMD check
make run    # run demo app
```

## Origin story

Vibe-coded across multiple AI editors — opencode, Copilot CLI, Antigravity. All three contributed. None of them asked for credit.

## See also

- [ellmer](https://ellmer.tidyverse.org) — talk to LLMs from R
- [shinychat](https://github.com/posit-dev/shinychat) — chat UI primitives (we build on this)
- [bslib](https://rstudio.github.io/bslib/) — Bootstrap for Shiny

## License

MIT
