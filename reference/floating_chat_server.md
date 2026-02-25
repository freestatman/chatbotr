# Floating Chat Server Module

Server logic for the floating chat module. This function wraps another
chat server module (like shinychat's server) within the floating chat
namespace.

## Usage

``` r
floating_chat_server(id, client, ...)
```

## Arguments

- id:

  Namespace ID matching the UI module

- client:

  Chat client object (from ellmer)

- ...:

  Additional arguments passed to chat_server_fun

## Value

Returns the result of the chat server function
