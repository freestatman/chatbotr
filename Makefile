# Default app
APP=floating_chat_demo.R

# Package development targets
.PHONY: install load test check document format clean coverage

install:
	R CMD INSTALL --no-multiarch --with-keep.source .

load:
	Rscript -e "pkgload::load_all()"

test:
	Rscript -e "devtools::test()"

check:
	R CMD check --no-multiarch --as-cran .

document:
	Rscript -e "devtools::document()"

format:
	air format .

coverage:
	Rscript -e "covr::package_coverage()" 

clean:
	rm -rf src/*.o src/*.so man/*.Rd

# Demo and example targets (all dependent on install)
.PHONY: run offcanvas floating byok byok-offcanvas btw-floating

run: install
	Rscript inst/examples/$(APP)

offcanvas: install
	Rscript inst/examples/offcanvas_chat_demo.R

floating: install
	Rscript inst/examples/floating_chat_demo.R

byok: install
	Rscript inst/examples/byok_floating_chat.R

byok-offcanvas: install
	Rscript inst/examples/byok_offcanvas_chat.R

btw-floating: install
	Rscript inst/examples/btw_floating_chat.R

# Help
.PHONY: help
help:
	@echo "=== R Package Development ==="
	@echo "  install    - Install package from source"
	@echo "  load       - Load package into R session (pkgload)"
	@echo "  test       - Run unit tests (testthat)"
	@echo "  check      - Run R CMD check (CRAN compliance)"
	@echo "  document   - Generate roxygen2 documentation"
	@echo "  format     - Format code with air package (required)"
	@echo "  coverage   - Generate test coverage report"
	@echo "  clean      - Remove build artifacts"
	@echo ""
	@echo "=== Demo Applications ==="
	@echo "  run            - Run default app (floating_chat_demo.R)"
	@echo "  offcanvas      - Run offcanvas_chat_demo.R"
	@echo "  floating       - Run floating_chat_demo.R"
	@echo "  byok           - Run byok_floating_chat.R"
	@echo "  byok-offcanvas - Run byok_offcanvas_chat.R"
	@echo "  btw-floating   - Run btw_floating_chat.R (R assistant with btw tools)"
	@echo ""
	@echo "=== Typical Workflow ==="
	@echo "  make load      - Load package for interactive development"
	@echo "  make format    - Format code (air)"
	@echo "  make document  - Generate documentation"
	@echo "  make test      - Run tests"
	@echo "  make check     - Final verification before commit"
