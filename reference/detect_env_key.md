# Detect API key from environment variables

Checks if any of the provider's supported environment variables are set
and returns information about the first one found.

## Usage

``` r
detect_env_key(provider)
```

## Arguments

- provider:

  Provider ID (e.g., "github", "openai", "anthropic")

## Value

A list with `var_name`, `key`, and `masked` (preview), or NULL if no
environment variable is set
