# Get environment variable names for a provider

Returns the environment variable name(s) that can be used for API key
authentication for a given provider. Some providers support multiple
environment variable names.

## Usage

``` r
get_provider_env_var(provider)
```

## Arguments

- provider:

  Provider ID (e.g., "github", "openai", "anthropic")

## Value

Character vector of environment variable names, or NULL if provider
doesn't use API keys (e.g., ollama)
