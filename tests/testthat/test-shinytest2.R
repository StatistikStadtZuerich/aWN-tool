library(shinytest2)

# Setup any PROXY setting here
http_proxy <- Sys.getenv("HTTP_PROXY")
Sys.setenv("HTTP_PROXY" = "")
chromote::set_chrome_args(paste0("--http-proxy=", http_proxy))


test_that("{shinytest2} recording: awn-tool starting values", {
  app <- AppDriver$new(name = "awn-tool", height = 953, width = 1619)
  app$set_inputs(`input_module-address` = "Vere")
  app$set_inputs(`input_module-address` = "Verenastrasse 16")
  app$click("ActionButtonId")
  app$set_window_size(width = 1619, height = 953)
  app$expect_values()
})


test_that("{shinytest2} recording: test_sorting_floor_correctly", {
  app <- AppDriver$new(name = "test_sorting_floor_correctly", height = 953, width = 1619)
  app$set_inputs(`input_module-address` = "z")
  app$set_inputs(`input_module-address` = "zähringer")
  app$set_inputs(`input_module-address` = "zähringerstrasse 2")
  app$set_inputs(`input_module-address` = "zähringerstrasse 27")
  app$set_inputs(`input_module-address` = "zähringerstrasse 2")
  app$set_inputs(`input_module-address` = "Zähringerstrasse 27")
  app$click("ActionButtonId")
  app$set_window_size(width = 1619, height = 953)
  app$expect_values()
})
