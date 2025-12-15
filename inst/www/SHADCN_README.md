# Shadcn-Style Floating Chat 🎨

A state-of-the-art floating chat interface for R Shiny applications, inspired by shadcn/ui design principles.

## ✨ What's New

The floating chat module now features a complete visual redesign with:

- 🎨 **Modern Design System**: CSS variables for consistent theming
- 🌗 **Light & Dark Themes**: Beautiful color palettes optimized for both modes
- ✨ **Smooth Animations**: Delightful micro-interactions with cubic-bezier easing
- ♿ **Full Accessibility**: ARIA labels, keyboard navigation, focus management
- 📱 **Responsive Layout**: Perfectly adapts from mobile to desktop
- 🎯 **shadcn/ui Inspired**: Clean, minimal, purposeful design

## 🎬 Demo

```r
# Run the basic demo
Rscript inst/examples/floating_chat_demo.R

# Run the full-featured demo with theme switcher
Rscript inst/examples/floating_chat_shadcn_demo.R
```

Then open http://127.0.0.1:7651 in your browser.

## 🚀 Quick Start

```r
library(shiny)
library(chatbotr)
library(ellmer)

ui <- page_fluid(
  floating_chat_ui(
    id = "chat",
    title = "AI Assistant",
    theme = "light",  # or "dark"
    trigger_position = "bottom-right",
    trigger_icon = "comment-dots",
    panel_width = 450,
    panel_height = 700,
    welcome_message = "Hello! How can I help you today?"
  )
)

server <- function(input, output, session) {
  floating_chat_server(
    id = "chat",
    client = chat_github()
  )
}

shinyApp(ui, server)
```

## 🎨 Theme Colors

### Light Theme
- Background: `#ffffff` (pure white)
- Foreground: `#0a0a0a` (near black)
- Muted: `#f4f4f5` (light gray)
- Border: `#e4e4e7` (subtle gray)

### Dark Theme
- Background: `#09090b` (near black)
- Foreground: `#fafafa` (off-white)
- Muted: `#27272a` (dark gray)
- Border: `#27272a` (subtle dark)

## ⚡ Key Features

### Design System
- CSS custom properties for consistent theming
- Modular color palette
- Consistent spacing scale (4px, 8px, 12px, 16px, 20px, 24px)
- Layered shadow system (sm, md, lg, xl, 2xl)

### Animations
- **Entrance**: Bouncy slide-in for trigger button
- **Panel**: Smooth scale with overshoot easing
- **Messages**: Fade-in slide animation
- **Typing**: Three-dot bouncing indicator
- **Interactions**: Micro-animations on hover/active

### Accessibility
- ARIA attributes on all interactive elements
- Keyboard navigation (Enter, Space, Escape)
- Auto-focus management
- Visible focus indicators
- Reduced motion support
- High contrast mode support

### Responsive
- Mobile: Full viewport (< 768px)
- Tablet: 90vw max (769-1024px)
- Desktop: Custom sizing (> 1024px)
- Touch-optimized

## 🎛️ Customization

### Basic Options

```r
floating_chat_ui(
  id = "chat",
  title = "Custom Title",
  theme = "dark",
  trigger_position = "bottom-right",  # or bottom-left, top-right, top-left
  trigger_icon = "robot",             # FontAwesome icon name
  trigger_size = 60,                  # pixels
  panel_width = 450,                  # pixels
  panel_height = 700,                 # pixels
  panel_offset = 20,                  # pixels from edge
  enable_minimize = TRUE,
  enable_maximize = TRUE
)
```

### Custom Colors

Override CSS variables in your app:

```css
.floating-chat-light {
  --chat-primary: #3b82f6;
  --chat-primary-fg: #ffffff;
}

.floating-chat-dark {
  --chat-primary: #60a5fa;
  --chat-primary-fg: #0f172a;
}
```

### Custom Animations

Modify easing functions:

```css
.floating-chat-panel {
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}
```

## 📚 Documentation

- **[SHADCN_STYLING.md](inst/www/SHADCN_STYLING.md)** - Complete styling guide
- **[SHADCN_IMPLEMENTATION.md](inst/www/SHADCN_IMPLEMENTATION.md)** - Implementation details
- **[style-guide.html](inst/www/style-guide.html)** - Visual style guide (open in browser)

## 🎯 Design Principles

Following shadcn/ui philosophy:

1. **Minimalism**: Clean, uncluttered interfaces
2. **Consistency**: CSS variables ensure uniformity
3. **Accessibility**: Built-in from the start
4. **Performance**: Hardware-accelerated animations
5. **Flexibility**: Easy to customize and extend

## 🌟 Advanced Features

### Notification Badge
```html
<div class="notification-badge">3</div>
```

### Status Indicator
```css
.status-indicator.online  /* Green */
.status-indicator.away    /* Yellow */
.status-indicator.offline /* Gray */
```

### Loading State
```html
<div class="floating-chat-panel loading">...</div>
```

## 📱 Browser Support

- ✅ Chrome/Edge (full support)
- ✅ Firefox (full support)
- ✅ Safari (full support)
- ✅ Mobile browsers (optimized)

## 🎓 Examples

### Light Theme Example
```r
floating_chat_ui(
  id = "light_chat",
  theme = "light",
  title = "Bright Assistant"
)
```

### Dark Theme Example
```r
floating_chat_ui(
  id = "dark_chat",
  theme = "dark",
  title = "Night Mode Chat"
)
```

### With Header Actions
```r
clear_btn <- actionButton("clear", icon = icon("trash"))

floating_chat_ui(
  id = "chat",
  header_actions = clear_btn
)
```

## 🔧 Development

```bash
# Load package
pkgload::load_all()

# Run tests
devtools::test()

# Check package
devtools::check()
```

## 📄 License

MIT License - see LICENSE file for details

## 🙏 Acknowledgments

- [shadcn/ui](https://ui.shadcn.com/) - Design inspiration
- [Radix UI](https://www.radix-ui.com/) - Component patterns
- [Tailwind CSS](https://tailwindcss.com/) - Color system

---

Made with ❤️ for the R Shiny community
