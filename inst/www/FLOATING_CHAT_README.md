# Floating Chat Module

A modern, floating chat interface module for R Shiny applications with customizable positioning and shadcn/ui-inspired design.

## Features

- **Floating Trigger Icon**: Discreet circular button that floats on top of your application
- **Customizable Positioning**: Place the trigger in any corner (bottom-right, bottom-left, top-right, top-left)
- **Smooth Animations**: Modern slide-in/out transitions with scale and opacity effects
- **Minimize Support**: Collapsible panel that can be minimized to just the header
- **Dark/Light Themes**: Built-in theming support with shadcn/ui-inspired colors
- **Responsive Design**: Automatically adapts to mobile screens
- **Overlay Background**: Dimmed backdrop when chat is open with click-to-close
- **Modular Design**: Works with any chat UI function (e.g., shinychat)

## Installation

Ensure you have the module files in your package:
- `R/floating_chat_module.R`
- `inst/www/floating_chat.css`

## Basic Usage

```r
library(shiny)
library(bslib)
library(shinychat)
library(ellmer)

ui <- page_fluid(
  theme = bs_theme(version = 5),
  
  # Include the custom CSS
  tags$head(
    tags$link(
      rel = "stylesheet",
      href = "floating_chat.css"
    )
  ),
  
  # Your main application content
  h1("My Application"),
  p("Your content here..."),
  
  # Floating chat module
  floating_chat_ui(
    id = "chat",
    title = "AI Assistant",
    trigger_position = "bottom-right",
    chat_ui_fun = shinychat::chat_ui
  )
)

server <- function(input, output, session) {
  # Initialize your chat client
  client <- ellmer::chat_github(
    system_prompt = "You are a helpful assistant."
  )
  
  # Connect the floating chat server
  floating_chat_server(
    id = "chat",
    chat_server_fun = shinychat::chat_server,
    client = client
  )
}

shinyApp(ui, server)
```

## Customization Options

### Position Variations

```r
# Bottom-right (default)
floating_chat_ui(
  id = "chat1",
  trigger_position = "bottom-right",
  chat_ui_fun = shinychat::chat_ui
)

# Bottom-left
floating_chat_ui(
  id = "chat2",
  trigger_position = "bottom-left",
  chat_ui_fun = shinychat::chat_ui
)

# Top-right
floating_chat_ui(
  id = "chat3",
  trigger_position = "top-right",
  chat_ui_fun = shinychat::chat_ui
)

# Top-left
floating_chat_ui(
  id = "chat4",
  trigger_position = "top-left",
  chat_ui_fun = shinychat::chat_ui
)
```

### Custom Sizing

```r
floating_chat_ui(
  id = "chat",
  trigger_size = 70,           # Larger trigger button
  panel_width = 500,           # Wider chat panel
  panel_height = 700,          # Taller chat panel
  panel_offset = 30,           # More spacing from edges
  chat_ui_fun = shinychat::chat_ui
)
```

### Theming

```r
# Dark theme
floating_chat_ui(
  id = "dark_chat",
  theme = "dark",
  title = "Dark Mode Assistant",
  chat_ui_fun = shinychat::chat_ui
)

# Light theme (default)
floating_chat_ui(
  id = "light_chat",
  theme = "light",
  title = "Light Mode Assistant",
  chat_ui_fun = shinychat::chat_ui
)
```

### Custom Icons and Actions

```r
floating_chat_ui(
  id = "chat",
  title = "Support Chat",
  trigger_icon = "headset",    # Different icon
  enable_minimize = TRUE,      # Enable minimize button
  header_actions = tagList(
    actionButton(
      "clear_chat",
      icon("trash"),
      class = "btn btn-sm btn-ghost"
    )
  ),
  chat_ui_fun = shinychat::chat_ui
)
```

### Integration with shinychat Module Pattern

```r
# If using shinychat's modular pattern
ui <- page_fluid(
  tags$head(tags$link(rel = "stylesheet", href = "floating_chat.css")),
  
  h1("Dashboard"),
  
  floating_chat_ui(
    id = "assistant",
    title = "AI Helper",
    chat_ui_fun = shinychat::chat_mod_ui,  # Module version
    chat_ui_args = list(
      placeholder = "Ask me anything...",
      # Additional chat_mod_ui arguments
    )
  )
)

server <- function(input, output, session) {
  client <- ellmer::chat_github()
  
  floating_chat_server(
    id = "assistant",
    chat_server_fun = shinychat::chat_mod_server,  # Module version
    client = client,
    # Additional chat_mod_server arguments
  )
}
```

## Advanced Features

### Adding Notification Badge

You can enhance the trigger button with a notification badge by modifying the trigger HTML:

```r
# Custom trigger with notification badge
custom_trigger <- tags$div(
  class = "floating-chat-trigger floating-chat-light pulse",
  tags$i(class = "fa fa-comments", style = "font-size: 28px;"),
  tags$span(class = "notification-badge", "3")
)
```

### Programmatic Control

To control the chat panel programmatically, you can use custom JavaScript:

```r
# In your UI
tags$button(
  "Open Chat",
  onclick = "document.getElementById('chat-trigger').click();"
)
```

### Multiple Chat Instances

You can have multiple floating chats with different configurations:

```r
ui <- page_fluid(
  tags$head(tags$link(rel = "stylesheet", href = "floating_chat.css")),
  
  # Support chat (bottom-right)
  floating_chat_ui(
    id = "support",
    title = "Support",
    trigger_position = "bottom-right",
    trigger_icon = "life-ring",
    chat_ui_fun = shinychat::chat_ui
  ),
  
  # Sales chat (bottom-left)
  floating_chat_ui(
    id = "sales",
    title = "Sales",
    trigger_position = "bottom-left",
    trigger_icon = "shopping-cart",
    chat_ui_fun = shinychat::chat_ui
  )
)
```

## Styling Customization

The module uses CSS custom properties that can be overridden:

```css
/* In your custom.css */
.floating-chat-light .floating-chat-trigger {
  background: linear-gradient(135deg, #your-color-1 0%, #your-color-2 100%);
}

.floating-chat-panel {
  border-radius: 16px; /* More rounded corners */
  box-shadow: 0 25px 60px rgba(0, 0, 0, 0.25); /* Stronger shadow */
}
```

## Responsive Behavior

On mobile devices (screens < 768px), the chat panel automatically:
- Expands to nearly full screen
- Maintains proper spacing from viewport edges
- Keeps the trigger button accessible

## Comparison with Offcanvas Module

| Feature | Floating Chat | Offcanvas Chat |
|---------|--------------|----------------|
| Position | Floating overlay | Fixed to edge |
| Trigger | Circular icon | Custom button |
| Animation | Scale + fade | Slide from edge |
| Mobile | Full screen | Edge-anchored |
| Use Case | Modern chatbot UX | Side panel navigation |

## Browser Support

- Chrome/Edge 90+
- Firefox 88+
- Safari 14+
- Mobile browsers (iOS Safari, Chrome Mobile)

## Dependencies

- R Shiny
- bslib (Bootstrap 5)
- Font Awesome (for icons)
- shinychat or compatible chat module

## License

[Your license here]
