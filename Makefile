.PHONY: document test check install load clean format help run run-byok run-offcanvas dev coverage site e2e

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

dev: format document load ## Fast dev loop: format, document, and load_all

document: ## Generate documentation (roxygen2)
	Rscript -e "devtools::document()"

test: ## Run unit tests
	Rscript -e "devtools::test()"

coverage: ## Check unit test coverage
	Rscript -e "covr::report()"

check: ## Run CRAN-style package checks
	R CMD check --no-multiarch --as-cran .

install: ## Install package locally
	R CMD INSTALL --no-multiarch --with-keep.source .

load: ## Load all functions (pkgload)
	Rscript -e "pkgload::load_all()"

format: ## Format R code
	air format .

site: ## Build package documentation site (pkgdown)
	Rscript -e "pkgdown::build_site()"

e2e: ## Run Playwright E2E tests (requires app running at localhost:3838)
	cd e2e && npx playwright test

clean: ## Remove build artifacts
	rm -rf man/*.Rd src/*.o src/*.so e2e/test-results e2e/playwright-report

run: install ## Run default demo
	Rscript inst/examples/floating_chat_demo.R

run-byok: install ## Run BYOK example
	Rscript inst/examples/byok_floating_chat.R

run-offcanvas: install ## Run offcanvas example
	Rscript inst/examples/offcanvas_chat_demo.R
