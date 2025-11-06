usethis::edit_r_environ()

library(ellmer)
chat <- chat_google_gemini(
  system = "You are a helpful assistant that provides information about the R for Data Science book by Hadley Wickham and Garrett Grolemund."
)
chat$chat("who are you")


library(ragnar)
ls("package:ragnar")
#  [1] "chunks_deoverlap"              "embed_bedrock"                 "embed_databricks"
#  [4] "embed_google_gemini"           "embed_google_vertex"           "embed_lm_studio"
#  [7] "embed_ollama"                  "embed_openai"                  "markdown_chunk"
# [10] "markdown_frame"                "markdown_segment"              "MarkdownDocument"
# [13] "MarkdownDocumentChunks"        "ragnar_chunk"                  "ragnar_chunk_segments"
# [16] "ragnar_chunks_view"            "ragnar_find_links"             "ragnar_read"
# [19] "ragnar_read_document"          "ragnar_register_tool_retrieve" "ragnar_retrieve"
# [22] "ragnar_retrieve_bm25"          "ragnar_retrieve_vss"           "ragnar_segment"
# [25] "ragnar_store_build_index"      "ragnar_store_connect"          "ragnar_store_create"
# [28] "ragnar_store_insert"           "ragnar_store_inspect"          "ragnar_store_update"
# [31] "read_as_markdown"

base_url <- "https://www.npmjs.com/package/create-shiny-react-app"
base_url <- "https://github.com/wch/create-shiny-react-app"
pages <- ragnar_find_links(base_url, depth = 0)
pages <- pages |> stringr::str_subset("main")
pages

store_location <- "shiny.react.shadcn.duckdb"

store <- ragnar_store_create(
  store_location,
  embed = \(x) ragnar::embed_google_gemini(x, model = "gemini-embedding-001")
)

for (page in pages) {
  message("ingesting: ", page)
  chunks <- page |> read_as_markdown() |> markdown_chunk()
  ragnar_store_insert(store, chunks)
}

ragnar_store_build_index(store)


#--------------------------
#retrieval-augmented generation (RAG)
#--------------------------

#' ## Retrieving Chunks

library(ragnar)
store_location <- "shiny.react.shadcn.duckdb"
store <- ragnar_store_connect(store_location, read_only = TRUE)

text <- "How to launch the project?"


#' # Retrieving Chunks
#' Once the store is set up, retrieve the most relevant text chunks like this

(relevant_chunks <- ragnar_retrieve(store, text))


#--------------------------
# chat bot
# --------------------------

#'  Register ellmer tool
#' You can register an ellmer tool to let the LLM retrieve chunks.
system_prompt <- stringr::str_squish(
  "
  You are an expert R shiny, react, and shadcn unicorn developer. You are concise.

  Before responding, retrieve relevant material from the knowledge store. Quote or
  paraphrase passages, clearly marking your own words versus the source. Provide a
  working link for every source cited, as well as any additional relevant links.
  Do not answer unless you have retrieved and cited a source.
  "
)
system_prompt

chat <- ellmer::chat_google_gemini(
  system_prompt,
  model = "gemini-2.5-pro"
)

ragnar_register_tool_retrieve(chat, store, top_k = 10)

chat$chat("How can I subset a dataframe?")
