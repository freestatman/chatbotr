# Offcanvas Chat Server Module

Server logic for the offcanvas chat module. This function wraps another
chat server module (like shinychat's server) within the offcanvas
namespace.

## Usage

``` r
offcanvas_chat_server(id, client, ...)
```

## Arguments

- id:

  Namespace ID matching the UI module

- client:

  Chat client object (from ellmer)

- ...:

  Additional arguments passed to chat_mod_server

## Value

Returns the result of the chat server function
