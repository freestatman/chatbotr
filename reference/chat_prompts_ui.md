# Generate suggested prompts UI

Creates the horizontal scrolling chip container for suggested prompts.

## Usage

``` r
chat_prompts_ui(prompts, border_color = "#e5e5e5", bg_color = "#fff")
```

## Arguments

- prompts:

  Character vector of prompt strings

- border_color:

  CSS color for the top border (default: "#e5e5e5")

- bg_color:

  CSS color for background (default: "#fff")

## Value

A shiny tags\$div or NULL if no prompts
