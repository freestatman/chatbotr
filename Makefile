# Default app
APP=floating_chat_demo.R

# Installation target
.PHONY: install
install:
	R CMD INSTALL --no-multiarch --with-keep.source .

# Simple run targets (all dependent on install)
.PHONY: run offcanvas floating shadcn ellmer byok byok-offcanvas

run: install
	Rscript inst/examples/$(APP)

offcanvas: install
	Rscript inst/examples/offcanvas_chat_demo.R

floating: install
	Rscript inst/examples/floating_chat_demo.R

shadcn: install
	Rscript inst/examples/floating_chat_shadcn_demo.R

ellmer: install
	Rscript inst/examples/ellmer.R

byok: install
	Rscript inst/examples/byok_floating_chat.R

byok-offcanvas: install
	Rscript inst/examples/byok_offcanvas_chat.R

# Help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  install        - Install the R package from source"
	@echo "  run            - Install and run default app (floating_chat_demo.R)"
	@echo "  offcanvas      - Install and run offcanvas_chat_demo.R"
	@echo "  floating       - Install and run floating_chat_demo.R"
	@echo "  shadcn         - Install and run floating_chat_shadcn_demo.R"
	@echo "  ellmer         - Install and run ellmer.R"
	@echo "  byok           - Install and run byok_floating_chat.R"
	@echo "  byok-offcanvas - Install and run byok_offcanvas_chat.R"
