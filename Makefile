# Default app
APP=floating_chat_demo.R

# Simple run targets
.PHONY: run offcanvas floating shadcn ellmer byok byok-offcanvas

run:
	Rscript inst/examples/$(APP)

offcanvas:
	Rscript inst/examples/offcanvas_chat_demo.R

floating:
	Rscript inst/examples/floating_chat_demo.R

shadcn:
	Rscript inst/examples/floating_chat_shadcn_demo.R

ellmer:
	Rscript inst/examples/ellmer.R

byok:
	Rscript inst/examples/byok_floating_chat.R

byok-offcanvas:
	Rscript inst/examples/byok_offcanvas_chat.R

# Help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  run            - Run default app (floating_chat_demo.R)"
	@echo "  offcanvas      - Run offcanvas_chat_demo.R"
	@echo "  floating       - Run floating_chat_demo.R"
	@echo "  shadcn         - Run floating_chat_shadcn_demo.R"
	@echo "  ellmer         - Run ellmer.R"
	@echo "  byok           - Run byok_floating_chat.R"
	@echo "  byok-offcanvas - Run byok_offcanvas_chat.R"
