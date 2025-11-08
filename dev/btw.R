library(btw)
library(ellmer)

# pkgload::load_all("~/workspaces/ewise_mind_api/emind/")
# Sys.setenv(EWISE_API_KEY = Sys.getenv("EWISE_TOKEN_INT"))

ls("package:btw")
#  [1] "btw"
#  [2] "btw_app"
#  [3] "btw_client"
#  [4] "btw_mcp_server"
#  [5] "btw_mcp_session"
#  [6] "btw_task_create_btw_md"
#  [7] "btw_task_create_readme"
#  [8] "btw_this"
#  [9] "btw_tool_docs_available_vignettes"
# [10] "btw_tool_docs_help_page"
# [11] "btw_tool_docs_package_help_topics"
# [12] "btw_tool_docs_package_news"
# [13] "btw_tool_docs_vignette"
# [14] "btw_tool_env_describe_data_frame"
# [15] "btw_tool_env_describe_environment"
# [16] "btw_tool_files_code_search"
# [17] "btw_tool_files_list_files"
# [18] "btw_tool_files_read_text_file"
# [19] "btw_tool_files_write_text_file"
# [20] "btw_tool_git_branch_checkout"
# [21] "btw_tool_git_branch_create"
# [22] "btw_tool_git_branch_list"
# [23] "btw_tool_git_commit"
# [24] "btw_tool_git_diff"
# [25] "btw_tool_git_log"
# [26] "btw_tool_git_status"
# [27] "btw_tool_github"
# [28] "btw_tool_ide_read_current_editor"
# [29] "btw_tool_search_package_info"
# [30] "btw_tool_search_packages"
# [31] "btw_tool_session_check_package_installed"
# [32] "btw_tool_session_package_info"
# [33] "btw_tool_session_platform_info"
# [34] "btw_tool_web_read_url"
# [35] "btw_tools"
# [36] "edit_btw_md"
# [37] "use_btw_md"
#

btw_app
btw_mcp_session()

library(mcptools)
ls("package:mcptools")
mcp_tools

chat <- chat_emind()
chat
chat <- chat_github()
chat

withr::local_options(list(
  # btw.client = chat_emind()
  btw.client = chat_github()
))

chat$get_provider()


btw(mtcars)
btw("{dplyr}", ?dplyr::across)
btw_client

list.files(system.file(package = "btw"), recursive = TRUE, full.names = TRUE)
#  [1] "/Users/i0508401/Library/R/arm64/4.4/library/btw/DESCRIPTION"
#  [2] "/Users/i0508401/Library/R/arm64/4.4/library/btw/help/aliases.rds"
#  [3] "/Users/i0508401/Library/R/arm64/4.4/library/btw/help/AnIndex"
#  [4] "/Users/i0508401/Library/R/arm64/4.4/library/btw/help/btw.rdb"
#  [5] "/Users/i0508401/Library/R/arm64/4.4/library/btw/help/btw.rdx"
#  [6] "/Users/i0508401/Library/R/arm64/4.4/library/btw/help/figures/btw-app.png"
#  [7] "/Users/i0508401/Library/R/arm64/4.4/library/btw/help/figures/logo.png"
#  [8] "/Users/i0508401/Library/R/arm64/4.4/library/btw/help/paths.rds"
#  [9] "/Users/i0508401/Library/R/arm64/4.4/library/btw/html/00Index.html"
# [10] "/Users/i0508401/Library/R/arm64/4.4/library/btw/html/R.css"
# [11] "/Users/i0508401/Library/R/arm64/4.4/library/btw/icons/code-blocks.svg"
# [12] "/Users/i0508401/Library/R/arm64/4.4/library/btw/icons/construction.svg"
# [13] "/Users/i0508401/Library/R/arm64/4.4/library/btw/icons/dictionary.svg"
# [14] "/Users/i0508401/Library/R/arm64/4.4/library/btw/icons/difference.svg"
# [15] "/Users/i0508401/Library/R/arm64/4.4/library/btw/icons/file-save.svg"
# [16] "/Users/i0508401/Library/R/arm64/4.4/library/btw/icons/folder-open.svg"
# [17] "/Users/i0508401/Library/R/arm64/4.4/library/btw/icons/git.svg"
# [18] "/Users/i0508401/Library/R/arm64/4.4/library/btw/icons/github.svg"
# [19] "/Users/i0508401/Library/R/arm64/4.4/library/btw/icons/globe-book.svg"
# [20] "/Users/i0508401/Library/R/arm64/4.4/library/btw/icons/LICENSE"
# [21] "/Users/i0508401/Library/R/arm64/4.4/library/btw/icons/new-label.svg"
# [22] "/Users/i0508401/Library/R/arm64/4.4/library/btw/icons/post-add.svg"
# [23] "/Users/i0508401/Library/R/arm64/4.4/library/btw/icons/quick-reference.svg"
# [24] "/Users/i0508401/Library/R/arm64/4.4/library/btw/icons/screen-search-desktop.svg"
# [25] "/Users/i0508401/Library/R/arm64/4.4/library/btw/icons/search.svg"
# [26] "/Users/i0508401/Library/R/arm64/4.4/library/btw/icons/source-environment.svg"
# [27] "/Users/i0508401/Library/R/arm64/4.4/library/btw/INDEX"
# [28] "/Users/i0508401/Library/R/arm64/4.4/library/btw/js/clean-url.js"
# [29] "/Users/i0508401/Library/R/arm64/4.4/library/btw/js/countupjs/btw_app.css"
# [30] "/Users/i0508401/Library/R/arm64/4.4/library/btw/js/countupjs/btw_app.js"
# [31] "/Users/i0508401/Library/R/arm64/4.4/library/btw/js/countupjs/countUp.min.js"
# [32] "/Users/i0508401/Library/R/arm64/4.4/library/btw/js/countupjs/LICENSE.md"
# [33] "/Users/i0508401/Library/R/arm64/4.4/library/btw/js/countupjs/VERSION"
# [34] "/Users/i0508401/Library/R/arm64/4.4/library/btw/LICENSE"
# [35] "/Users/i0508401/Library/R/arm64/4.4/library/btw/Meta/features.rds"
# [36] "/Users/i0508401/Library/R/arm64/4.4/library/btw/Meta/hsearch.rds"
# [37] "/Users/i0508401/Library/R/arm64/4.4/library/btw/Meta/links.rds"
# [38] "/Users/i0508401/Library/R/arm64/4.4/library/btw/Meta/nsInfo.rds"
# [39] "/Users/i0508401/Library/R/arm64/4.4/library/btw/Meta/package.rds"
# [40] "/Users/i0508401/Library/R/arm64/4.4/library/btw/Meta/Rd.rds"
# [41] "/Users/i0508401/Library/R/arm64/4.4/library/btw/NAMESPACE"
# [42] "/Users/i0508401/Library/R/arm64/4.4/library/btw/NEWS.md"
# [43] "/Users/i0508401/Library/R/arm64/4.4/library/btw/prompts/btw-create-readme.md"
# [44] "/Users/i0508401/Library/R/arm64/4.4/library/btw/prompts/btw-init.md"
# [45] "/Users/i0508401/Library/R/arm64/4.4/library/btw/prompts/btw-system_project.md"
# [46] "/Users/i0508401/Library/R/arm64/4.4/library/btw/prompts/btw-system_session.md"
# [47] "/Users/i0508401/Library/R/arm64/4.4/library/btw/prompts/btw-system_tools.md"
# [48] "/Users/i0508401/Library/R/arm64/4.4/library/btw/R/btw"
# [49] "/Users/i0508401/Library/R/arm64/4.4/library/btw/R/btw.rdb"
# [50] "/Users/i0508401/Library/R/arm64/4.4/library/btw/R/btw.rdx"
# [51] "/Users/i0508401/Library/R/arm64/4.4/library/btw/rstudio/addins.dcf"
# [52] "/Users/i0508401/Library/R/arm64/4.4/library/btw/templates/AGENTS.md"
# [53] "/Users/i0508401/Library/R/arm64/4.4/library/btw/templates/btw.md"
# [54] "/Users/i0508401/Library/R/arm64/4.4/library/btw/WORDLIST"

btw:::read_llms_txt()

btw_client
# function (..., client = NULL, tools = NULL, path_btw = NULL,
#     path_llms_txt = NULL)
# {
#     check_dots_empty()
#     config <- btw_client_config(client, tools, config = read_btw_file(path_btw))
#     client <- config$client
#     skip_tools <- isFALSE(config$tools) || identical(config$tools,
#         "none")
#     withr::local_options(config$options)
#     session_info <- btw_tool_session_platform_info()@value
#     client_system_prompt <- client$get_system_prompt()
#     llms_txt <- read_llms_txt(path_llms_txt)
#     project_context <- c(llms_txt, config$btw_system_prompt)
#     project_context <- paste(project_context, collapse = "\n\n")
#     sys_prompt <- c(btw_prompt("btw-system_session.md"), if (!skip_tools) {
#         btw_prompt("btw-system_tools.md")
#     }, if (nzchar(project_context)) {
#         btw_prompt("btw-system_project.md")
#     }, if (!is.null(client_system_prompt)) "---", paste(client_system_prompt,
#         collapse = "\n"))
#     client$set_system_prompt(paste(sys_prompt, collapse = "\n\n"))
#     if (!skip_tools) {
#         client$set_tools(tools = c(client$get_tools(), config$tools))
#     }
#     client
# }
# <bytecode: 0x13d03d9e0>
# <environment: namespace:btw>

library(btw)
chat <- btw_client()
chat$get_model()

chat$chat(
  "How can I make a offcan"
)


# bslib::offcanvas
chat$chat(
  "How can I replace `stop()` calls with functions from the cli package?"
)

chat$get_tokens()
chat |> live_browser()

saveRDS(chat, "chat_emind-20251106.rds")


#' Get all public method names from an R6 object
#'
#' @param obj An R6 object instance.
#' @return A character vector of public method names.
get_public_methods <- function(obj) {
  # 1. Get all public member names
  all_names <- names(obj)

  # 2. Find out which ones are functions
  # We use sapply to apply is.function to each member
  is_method <- sapply(all_names, function(name) {
    # Access the member using `[[` and check if it's a function
    is.function(obj[[name]])
  })

  # 3. Return the names where is_method is TRUE
  return(all_names[is_method])
}

# --- Using our object 'p' from before ---
method_names <- get_public_methods(chat)
#  [1] "stream_async"          "stream"                "set_turns"             "set_tools"             "set_system_prompt"     "register_tools"        "register_tool"         "on_tool_result"
#  [9] "on_tool_request"       "last_turn"             "initialize"            "get_turns"             "get_tools"             "get_tokens"            "get_system_prompt"     "get_provider"
# [17] "get_model"             "get_cost"              "extract_data_async"    "extract_data"          "clone"                 "chat_structured_async" "chat_structured"       "chat_async"
# [25] "chat"                  "add_turn"
names(chat)

library(dplyr)
chat$get_model()
chat$get_tools()
chat$last_turn()
chat$get_turns()
chat$get_tools() %>% names
#  [1] "btw_tool_env_describe_data_frame"         "btw_tool_docs_package_news"               "btw_tool_docs_package_help_topics"        "btw_tool_docs_help_page"
#  [5] "btw_tool_docs_available_vignettes"        "btw_tool_docs_vignette"                   "btw_tool_env_describe_environment"        "btw_tool_files_code_search"
#  [9] "btw_tool_files_list_files"                "btw_tool_files_read_text_file"            "btw_tool_files_write_text_file"           "btw_tool_git_status"
# [13] "btw_tool_git_diff"                        "btw_tool_git_log"                         "btw_tool_git_commit"                      "btw_tool_git_branch_list"
# [17] "btw_tool_git_branch_create"               "btw_tool_git_branch_checkout"             "btw_tool_github"                          "btw_tool_search_packages"
# [21] "btw_tool_search_package_info"             "btw_tool_session_check_package_installed" "btw_tool_session_platform_info"           "btw_tool_session_package_info"
# [25] "btw_tool_web_read_url"

chat$get_system_prompt()
chat$extract_data()
chat$chat_structured()
chat$get_tokens()

chat$get_turns

chat <- readRDS("chat_emind-20251106.rds")


btw_app()
