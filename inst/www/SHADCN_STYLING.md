# Shadcn-Inspired Floating Chat Styling

This document describes the state-of-the-art shadcn/ui inspired styling applied to the floating chat module.

## Design Philosophy

The styling follows shadcn/ui's design principles:

1. **Minimalism**: Clean, uncluttered interfaces with purposeful whitespace
2. **Consistency**: CSS variables ensure consistent theming throughout
3. **Accessibility**: ARIA labels, keyboard navigation, and focus states
4. **Performance**: Hardware-accelerated animations with cubic-bezier easing
5. **Responsiveness**: Fluid layouts that adapt from mobile to desktop

## Color System

### CSS Variables

The design uses CSS custom properties for dynamic theming:

#### Light Theme
```css
--chat-bg: #ffffff          /* Pure white background */
--chat-fg: #0a0a0a          /* Near-black text */
--chat-primary: #0a0a0a     /* Primary action color */
--chat-secondary: #f4f4f5   /* Subtle backgrounds */
--chat-muted: #f4f4f5       /* Muted backgrounds */
--chat-muted-fg: #71717a    /* Secondary text */
--chat-border: #e4e4e7      /* Borders and dividers */
```

#### Dark Theme
```css
--chat-bg: #09090b          /* Near-black background */
--chat-fg: #fafafa          /* Off-white text */
--chat-primary: #fafafa     /* Primary action color */
--chat-secondary: #27272a   /* Subtle backgrounds */
--chat-muted: #27272a       /* Muted backgrounds */
--chat-muted-fg: #a1a1aa    /* Secondary text */
--chat-border: #27272a      /* Borders and dividers */
```

## Typography

- **Font Weight**: 600 for headings, 500 for buttons, 400 for body
- **Font Size**: 0.875rem (14px) base, with relative scaling
- **Letter Spacing**: -0.01em for tighter, modern look
- **Line Height**: 1.5 for optimal readability

## Spacing

Follows a consistent spacing scale:
- 0.25rem (4px) - Micro spacing
- 0.5rem (8px) - Small gaps
- 0.75rem (12px) - Default gap
- 1rem (16px) - Medium spacing
- 1.25rem (20px) - Large spacing
- 1.5rem (24px) - Extra large spacing

## Shadows

Layered shadow system for depth:

```css
--chat-shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05)
--chat-shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1)
--chat-shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1)
--chat-shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1)
--chat-shadow-2xl: 0 25px 50px -12px rgb(0 0 0 / 0.25)
```

## Border Radius

- **Default**: 0.75rem (12px) for panels and cards
- **Nested**: calc(var(--chat-radius) - 2px) for inner elements
- **Full**: 50% for circular buttons and avatars

## Animations

### Entrance Animation
The trigger button uses a bouncy entrance:
```css
@keyframes slideInBounce {
  0% { opacity: 0; transform: scale(0.3) translateY(20px); }
  50% { transform: scale(1.05) translateY(-5px); }
  100% { opacity: 1; transform: scale(1) translateY(0); }
}
```

### Panel Animation
The chat panel slides in with overshoot:
```css
transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
```

### Message Animation
Messages fade in from below:
```css
@keyframes messageSlideIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
```

### Typing Indicator
Three dots bounce in sequence:
```css
@keyframes typingDot {
  0%, 60%, 100% { transform: translateY(0); opacity: 0.6; }
  30% { transform: translateY(-8px); opacity: 1; }
}
```

## Interactive States

### Buttons
- **Hover**: Background change + subtle transform
- **Active**: Scale down to 0.95
- **Focus**: 2px outline with offset

### Trigger Button
- **Hover**: Scale to 1.05 + shadow increase
- **Active**: Scale to 0.92
- **Pulse**: Optional animation for attention

## Accessibility Features

1. **ARIA Attributes**:
   - `role="button"` and `role="dialog"`
   - `aria-label` for all interactive elements
   - `aria-modal="true"` for panel

2. **Keyboard Navigation**:
   - Tab through all controls
   - Enter/Space to activate trigger
   - Escape to close panel
   - Focus management (auto-focus input on open)

3. **Focus Indicators**:
   - Visible focus ring (2px outline)
   - High contrast support
   - Reduced motion support

## Responsive Breakpoints

### Mobile (< 480px)
- Trigger: 3rem × 3rem
- Panel: Full viewport
- No border radius

### Tablet (481-768px)
- Trigger: 3.5rem × 3.5rem
- Panel: Full viewport
- No border radius

### Tablet Landscape (769-1024px)
- Panel: 90vw max 500px
- Panel: 80vh max 700px

### Desktop (> 1024px)
- Default sizing applies
- Panel maintains defined dimensions

## Advanced Features

### Notification Badge
```css
.notification-badge {
  position: absolute;
  top: -0.25rem;
  right: -0.25rem;
  background: #ef4444;
  animation: badgeBounce 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
}
```

### Status Indicator
```css
.status-indicator {
  width: 0.875rem;
  height: 0.875rem;
  border-radius: 50%;
  background: #22c55e; /* Green for online */
}
```

### Loading State
```css
.loading::after {
  content: '';
  height: 2px;
  background: linear-gradient(90deg, transparent, var(--chat-primary), transparent);
  animation: loading 1.5s infinite;
}
```

## Customization

### Changing Theme
The theme is controlled via CSS variables. You can override them:

```r
floating_chat_ui(
  id = "chat",
  theme = "dark"  # or "light"
)
```

### Custom Colors
Override CSS variables in your app:

```css
.floating-chat-light {
  --chat-primary: #3b82f6;
  --chat-primary-fg: #ffffff;
}
```

### Custom Animations
Disable or modify animations:

```css
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

## Browser Support

- Chrome/Edge: Full support
- Firefox: Full support
- Safari: Full support (with -webkit- prefixes for backdrop-filter)
- Mobile browsers: Optimized for touch

## Performance

- Hardware-accelerated transforms (translate, scale)
- Will-change hints for animated elements
- Debounced resize handlers
- Efficient CSS selectors

## Best Practices

1. **Always provide ARIA labels** for accessibility
2. **Test with keyboard navigation** before deploying
3. **Verify contrast ratios** meet WCAG AA standards
4. **Test on mobile devices** for touch interactions
5. **Check reduced motion preferences** for users with vestibular disorders

## Examples

See the demo files for implementation examples:
- `inst/examples/floating_chat_demo.R` - Basic demo
- `inst/examples/floating_chat_shadcn_demo.R` - Full-featured demo with theme switcher
