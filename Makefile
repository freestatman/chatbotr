
APP=floating_chat_demo.R
run:
	Rscript inst/examples/$(APP)

app1:
	Rscript inst/examples/floating_chat_demo.R

app2:
	Rscript inst/examples/offcanvas_chat_demo.R
