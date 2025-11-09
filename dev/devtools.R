library(devtools)
load_all()
getwd()

document()
test()


source(system.file("examples/floating_chat_demo.R", package = "chatbotr"))
shiny::runGadget(
  ui,
  server
)
