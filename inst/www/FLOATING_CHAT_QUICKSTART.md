# Floating Chat Module - Quick Start Guide

## Installation

The floating chat module is now part of your chatbot_r package. No additional installation needed!

## 5-Minute Setup

### Step 1: Include the CSS

Add the floating chat CSS to your app's UI:

```r
library(shiny)
library(bslib)

ui <- page_fluid(
  # Include the CSS
  tags$head(
    tags$link(rel = "stylesheet", href = "floating_chat.css")
  ),
  
  # Your app content here
  h1("My App")
)
```

### Step 2: Add the Floating Chat UI

```r
ui <- page_fluid(
  tags$head(
    tags$link(rel = "stylesheet", href = "floating_chat.css")
  ),
  
  h1("My App"),
  
  # Add floating chat
  floating_chat_ui(
    id = "chat",
    chat_ui_fun = shinychat::chat_ui
  )
)
```

### Step 3: Connect the Server

```r
server <- function(input, output, session) {
  # Setup your chat client
  client <- ellmer::chat_github(
    system_prompt = "You are a helpful assistant."
  )
  
  # Connect the server
  floating_chat_server(
    id = "chat",
    chat_server_fun = shinychat::chat_server,
    client = client
  )
}
```

### Step 4: Run Your App

```r
shinyApp(ui, server)
```

That's it! You now have a beautiful floating chat interface.

## Customization Examples

### Change Position

```r
floating_chat_ui(
  id = "chat",
  trigger_position = "bottom-left",  # or top-right, top-left
  chat_ui_fun = shinychat::chat_ui
)
```

### Use Dark Theme

```r
floating_chat_ui(
  id = "chat",
  theme = "dark",
  chat_ui_fun = shinychat::chat_ui
)
```

### Customize Size

```r
floating_chat_ui(
  id = "chat",
  trigger_size = 70,
  panel_width = 500,
  panel_height = 700,
  chat_ui_fun = shinychat::chat_ui
)
```

### Add Custom Actions

```r
floating_chat_ui(
  id = "chat",
  header_actions = actionButton(
    "clear",
    icon("trash"),
    class = "btn btn-sm btn-ghost"
  ),
  chat_ui_fun = shinychat::chat_ui
)
```

## Key Features

✨ **Modern Design**: shadcn/ui inspired styling with smooth animations

🎯 **Flexible Positioning**: Place the trigger in any corner

🌗 **Dark/Light Themes**: Built-in theme support

📱 **Responsive**: Automatically adapts to mobile screens

⚡ **Performance**: Lightweight with smooth 60fps animations

🎨 **Customizable**: Extensive customization options

## Comparison: Floating vs Offcanvas

| Feature | Floating Chat | Offcanvas Chat |
|---------|---------------|----------------|
| **Trigger** | Circular floating icon | Custom button |
| **Position** | Floating overlay | Fixed to screen edge |
| **Animation** | Scale + fade | Slide from edge |
| **Use Case** | Modern chatbot UX | Side panel/drawer |
| **Mobile** | Full screen overlay | Edge-anchored panel |

## Need Help?

- Check the full documentation: `inst/www/FLOATING_CHAT_README.md`
- Run the demo: `inst/examples/floating_chat_demo.R`
- See `man/floating_chat_ui.Rd` for all parameters

## Next Steps

1. Customize the colors in `floating_chat.css`
2. Add notification badges for new messages
3. Integrate with your preferred chat backend
4. Experiment with different positions and sizes

Happy coding! 🚀
