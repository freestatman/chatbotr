# Default app to run
APP=floating_chat_demo.R

# Port configuration for each app
PORT_APP1=3838
PORT_APP2=3839
PORT_BYOK=3840
PORT_BYOK1=3841
DEFAULT_PORT=$(PORT_APP2)

# Browser-sync proxy ports (Shiny port + 1000)
BS_PORT_APP1=8838
BS_PORT_APP2=8839
BS_PORT_BYOK=8840
BS_PORT_BYOK1=8841
BS_DEFAULT_PORT=$(BS_PORT_APP2)

# Source files to watch for changes
R_FILES := $(wildcard R/*.R)
EXAMPLE_FILES := $(wildcard inst/examples/*.R)
CSS_FILES := $(wildcard inst/www/*.css)
WATCH_FILES := $(R_FILES) $(CSS_FILES)

# Basic run targets (no auto-reload)
.PHONY: run app1 app2 byok byok1
run:
	Rscript -e "options(shiny.port = $(DEFAULT_PORT)); shiny::runApp('inst/examples/$(APP)', launch.browser = TRUE)"

app1:
	Rscript -e "options(shiny.port = $(PORT_APP1)); shiny::runApp('inst/examples/offcanvas_chat_demo.R', launch.browser = TRUE)"

app2:
	Rscript -e "options(shiny.port = $(PORT_APP2)); shiny::runApp('inst/examples/floating_chat_demo.R', launch.browser = TRUE)"

byok:
	Rscript -e "options(shiny.port = $(PORT_BYOK)); shiny::runApp('inst/examples/byok_floating_chat.R', launch.browser = TRUE)"

byok1:
	Rscript -e "options(shiny.port = $(PORT_BYOK1)); shiny::runApp('inst/examples/byok_offcanvas_chat.R', launch.browser = TRUE)"

# Auto-reload targets using inotifywait (Linux)
.PHONY: watch watch-app1 watch-app2 watch-byok watch-byok1
watch:
	@echo "Watching for changes in R/ and inst/www/..."
	@echo "Running on port $(DEFAULT_PORT)"
	@echo "Press Ctrl+C to stop"
	@while true; do \
		Rscript -e "options(shiny.port = $(DEFAULT_PORT)); shiny::runApp('inst/examples/$(APP)', launch.browser = FALSE)" & \
		PID=$$!; \
		inotifywait -q -e modify,create,delete $(R_FILES) $(CSS_FILES) inst/examples/$(APP); \
		echo "Change detected, restarting app..."; \
		kill $$PID 2>/dev/null || true; \
		pkill -P $$PID 2>/dev/null || true; \
		sleep 1; \
	done

watch-app1:
	@echo "Watching offcanvas_chat_demo.R and dependencies..."
	@echo "Running on port $(PORT_APP1)"
	@echo "Open http://localhost:$(PORT_APP1) in your browser"
	@echo "Press Ctrl+C to stop"
	@while true; do \
		Rscript -e "options(shiny.port = $(PORT_APP1)); shiny::runApp('inst/examples/offcanvas_chat_demo.R', launch.browser = FALSE)" & \
		PID=$$!; \
		inotifywait -q -e modify,create,delete $(R_FILES) $(CSS_FILES) inst/examples/offcanvas_chat_demo.R; \
		echo "Change detected, restarting app..."; \
		kill $$PID 2>/dev/null || true; \
		pkill -P $$PID 2>/dev/null || true; \
		sleep 1; \
	done

watch-app2:
	@echo "Watching floating_chat_demo.R and dependencies..."
	@echo "Running on port $(PORT_APP2)"
	@echo "Open http://localhost:$(PORT_APP2) in your browser"
	@echo "Press Ctrl+C to stop"
	@while true; do \
		Rscript -e "options(shiny.port = $(PORT_APP2)); shiny::runApp('inst/examples/floating_chat_demo.R', launch.browser = FALSE)" & \
		PID=$$!; \
		inotifywait -q -e modify,create,delete $(R_FILES) $(CSS_FILES) inst/examples/floating_chat_demo.R; \
		echo "Change detected, restarting app..."; \
		kill $$PID 2>/dev/null || true; \
		pkill -P $$PID 2>/dev/null || true; \
		sleep 1; \
	done

watch-byok:
	@echo "Watching byok_floating_chat.R and dependencies..."
	@echo "Running on port $(PORT_BYOK)"
	@echo "Open http://localhost:$(PORT_BYOK) in your browser"
	@echo "Press Ctrl+C to stop"
	@while true; do \
		Rscript -e "options(shiny.port = $(PORT_BYOK)); shiny::runApp('inst/examples/byok_floating_chat.R', launch.browser = FALSE)" & \
		PID=$$!; \
		inotifywait -q -e modify,create,delete $(R_FILES) $(CSS_FILES) inst/examples/byok_floating_chat.R; \
		echo "Change detected, restarting app..."; \
		kill $$PID 2>/dev/null || true; \
		pkill -P $$PID 2>/dev/null || true; \
		sleep 1; \
	done

watch-byok1:
	@echo "Watching byok_offcanvas_chat.R and dependencies..."
	@echo "Running on port $(PORT_BYOK1)"
	@echo "Open http://localhost:$(PORT_BYOK1) in your browser"
	@echo "Press Ctrl+C to stop"
	@while true; do \
		Rscript -e "options(shiny.port = $(PORT_BYOK1)); shiny::runApp('inst/examples/byok_offcanvas_chat.R', launch.browser = FALSE)" & \
		PID=$$!; \
		inotifywait -q -e modify,create,delete $(R_FILES) $(CSS_FILES) inst/examples/byok_offcanvas_chat.R; \
		echo "Change detected, restarting app..."; \
		kill $$PID 2>/dev/null || true; \
		pkill -P $$PID 2>/dev/null || true; \
		sleep 1; \
	done

# Browser-sync auto-reload targets (with automatic browser refresh)
.PHONY: dev dev-app1 dev-app2 dev-byok dev-byok1
dev:
	@echo "Starting Shiny app with auto-refresh..."
	@echo "Shiny running on port $(DEFAULT_PORT)"
	@echo "Browser-sync running on port $(BS_DEFAULT_PORT)"
	@echo "Open http://localhost:$(BS_DEFAULT_PORT) in your browser"
	@echo "Press Ctrl+C to stop"
	@echo ""
	@trap 'pkill -P $$$$; exit' INT TERM EXIT; \
	browser-sync start --proxy "localhost:$(DEFAULT_PORT)" --port $(BS_DEFAULT_PORT) --no-open --no-notify & \
	BS_PID=$$!; \
	sleep 2; \
	while true; do \
		Rscript -e "options(shiny.port = $(DEFAULT_PORT)); shiny::runApp('inst/examples/$(APP)', launch.browser = FALSE)" & \
		SHINY_PID=$$!; \
		inotifywait -q -e modify,create,delete $(R_FILES) $(CSS_FILES) inst/examples/$(APP); \
		echo "Change detected, restarting Shiny app..."; \
		kill $$SHINY_PID 2>/dev/null || true; \
		pkill -P $$SHINY_PID 2>/dev/null || true; \
		sleep 2; \
	done

dev-app1:
	@echo "Starting offcanvas_chat_demo.R with auto-refresh..."
	@echo "Shiny running on port $(PORT_APP1)"
	@echo "Browser-sync running on port $(BS_PORT_APP1)"
	@echo "Open http://localhost:$(BS_PORT_APP1) in your browser"
	@echo "Press Ctrl+C to stop"
	@echo ""
	@trap 'pkill -P $$$$; exit' INT TERM EXIT; \
	browser-sync start --proxy "localhost:$(PORT_APP1)" --port $(BS_PORT_APP1) --no-open --no-notify & \
	BS_PID=$$!; \
	sleep 2; \
	while true; do \
		Rscript -e "options(shiny.port = $(PORT_APP1)); shiny::runApp('inst/examples/offcanvas_chat_demo.R', launch.browser = FALSE)" & \
		SHINY_PID=$$!; \
		inotifywait -q -e modify,create,delete $(R_FILES) $(CSS_FILES) inst/examples/offcanvas_chat_demo.R; \
		echo "Change detected, restarting Shiny app..."; \
		kill $$SHINY_PID 2>/dev/null || true; \
		pkill -P $$SHINY_PID 2>/dev/null || true; \
		sleep 2; \
	done

dev-app2:
	@echo "Starting floating_chat_demo.R with auto-refresh..."
	@echo "Shiny running on port $(PORT_APP2)"
	@echo "Browser-sync running on port $(BS_PORT_APP2)"
	@echo "Open http://localhost:$(BS_PORT_APP2) in your browser"
	@echo "Press Ctrl+C to stop"
	@echo ""
	@trap 'pkill -P $$$$; exit' INT TERM EXIT; \
	browser-sync start --proxy "localhost:$(PORT_APP2)" --port $(BS_PORT_APP2) --no-open --no-notify & \
	BS_PID=$$!; \
	sleep 2; \
	while true; do \
		Rscript -e "options(shiny.port = $(PORT_APP2)); shiny::runApp('inst/examples/floating_chat_demo.R', launch.browser = FALSE)" & \
		SHINY_PID=$$!; \
		inotifywait -q -e modify,create,delete $(R_FILES) $(CSS_FILES) inst/examples/floating_chat_demo.R; \
		echo "Change detected, restarting Shiny app..."; \
		kill $$SHINY_PID 2>/dev/null || true; \
		pkill -P $$SHINY_PID 2>/dev/null || true; \
		sleep 2; \
	done

dev-byok:
	@echo "Starting byok_floating_chat.R with auto-refresh..."
	@echo "Shiny running on port $(PORT_BYOK)"
	@echo "Browser-sync running on port $(BS_PORT_BYOK)"
	@echo "Open http://localhost:$(BS_PORT_BYOK) in your browser"
	@echo "Press Ctrl+C to stop"
	@echo ""
	@trap 'pkill -P $$$$; exit' INT TERM EXIT; \
	browser-sync start --proxy "localhost:$(PORT_BYOK)" --port $(BS_PORT_BYOK) --no-open --no-notify & \
	BS_PID=$$!; \
	sleep 2; \
	while true; do \
		Rscript -e "options(shiny.port = $(PORT_BYOK)); shiny::runApp('inst/examples/byok_floating_chat.R', launch.browser = FALSE)" & \
		SHINY_PID=$$!; \
		inotifywait -q -e modify,create,delete $(R_FILES) $(CSS_FILES) inst/examples/byok_floating_chat.R; \
		echo "Change detected, restarting Shiny app..."; \
		kill $$SHINY_PID 2>/dev/null || true; \
		pkill -P $$SHINY_PID 2>/dev/null || true; \
		sleep 2; \
	done

dev-byok1:
	@echo "Starting byok_offcanvas_chat.R with auto-refresh..."
	@echo "Shiny running on port $(PORT_BYOK1)"
	@echo "Browser-sync running on port $(BS_PORT_BYOK1)"
	@echo "Open http://localhost:$(BS_PORT_BYOK1) in your browser"
	@echo "Press Ctrl+C to stop"
	@echo ""
	@trap 'pkill -P $$$$; exit' INT TERM EXIT; \
	browser-sync start --proxy "localhost:$(PORT_BYOK1)" --port $(BS_PORT_BYOK1) --no-open --no-notify & \
	BS_PID=$$!; \
	sleep 2; \
	while true; do \
		Rscript -e "options(shiny.port = $(PORT_BYOK1)); shiny::runApp('inst/examples/byok_offcanvas_chat.R', launch.browser = FALSE)" & \
		SHINY_PID=$$!; \
		inotifywait -q -e modify,create,delete $(R_FILES) $(CSS_FILES) inst/examples/byok_offcanvas_chat.R; \
		echo "Change detected, restarting Shiny app..."; \
		kill $$SHINY_PID 2>/dev/null || true; \
		pkill -P $$SHINY_PID 2>/dev/null || true; \
		sleep 2; \
	done

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo ""
	@echo "Basic run (with browser launch):"
	@echo "  run           - Run default app on port $(DEFAULT_PORT)"
	@echo "  app1          - Run offcanvas_chat_demo.R on port $(PORT_APP1)"
	@echo "  app2          - Run floating_chat_demo.R on port $(PORT_APP2)"
	@echo "  byok          - Run byok_floating_chat.R on port $(PORT_BYOK)"
	@echo "  byok1         - Run byok_offcanvas_chat.R on port $(PORT_BYOK1)"
	@echo ""
	@echo "Auto-reload with browser refresh (recommended for development):"
	@echo "  dev           - Run default app with browser-sync (port $(BS_DEFAULT_PORT))"
	@echo "  dev-app1      - Run offcanvas_chat_demo.R with browser-sync (port $(BS_PORT_APP1))"
	@echo "  dev-app2      - Run floating_chat_demo.R with browser-sync (port $(BS_PORT_APP2))"
	@echo "  dev-byok      - Run byok_floating_chat.R with browser-sync (port $(BS_PORT_BYOK))"
	@echo "  dev-byok1     - Run byok_offcanvas_chat.R with browser-sync (port $(BS_PORT_BYOK1))"
	@echo ""
	@echo "Auto-reload without browser refresh (requires inotify-tools):"
	@echo "  watch         - Watch and auto-reload default app (port $(DEFAULT_PORT))"
	@echo "  watch-app1    - Watch offcanvas_chat_demo.R (port $(PORT_APP1))"
	@echo "  watch-app2    - Watch floating_chat_demo.R (port $(PORT_APP2))"
	@echo "  watch-byok    - Watch byok_floating_chat.R (port $(PORT_BYOK))"
	@echo "  watch-byok1   - Watch byok_offcanvas_chat.R (port $(PORT_BYOK1))"
	@echo ""
	@echo "Port Configuration:"
	@echo "  Shiny Ports:        Browser-sync Ports:"
	@echo "  app1  -> $(PORT_APP1)         dev-app1  -> $(BS_PORT_APP1)"
	@echo "  app2  -> $(PORT_APP2)         dev-app2  -> $(BS_PORT_APP2)"
	@echo "  byok  -> $(PORT_BYOK)         dev-byok  -> $(BS_PORT_BYOK)"
	@echo "  byok1 -> $(PORT_BYOK1)         dev-byok1 -> $(BS_PORT_BYOK1)"
	@echo ""
	@echo "Installation:"
	@echo "  Install inotify-tools: sudo apt-get install inotify-tools"
	@echo "  Install browser-sync:  sudo npm install -g browser-sync"
	@echo ""
	@echo "Note: Browser-sync targets (dev-*) automatically refresh your browser when files change!"
