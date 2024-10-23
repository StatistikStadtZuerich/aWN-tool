library(shinytest2)

# Setup any PROXY setting here
http_proxy <- Sys.getenv("HTTP_PROXY")
Sys.setenv("HTTP_PROXY" = "")
chromote::set_chrome_args(paste0("--http-proxy=", http_proxy))


test_that("{shinytest2} recording: awn-tool starting values", {
  app <- AppDriver$new(name = "awn-tool", height = 953, width = 1619)
  app$set_inputs(`input_module-address` = "Verenastrasse 16")
  app$click("ActionButtonId")
  app$set_window_size(width = 1619, height = 953)
  app$expect_values(input = TRUE,
                    output = FALSE, 
                    export = TRUE
  )
})


test_that("{shinytest2} recording: test_sorting_floor_correctly", {
  app <- AppDriver$new(name = "test_sorting_floor_correctly", height = 953, width = 1619)
  app$set_inputs(`input_module-address` = "Zähringerstrasse 27")
  app$click("ActionButtonId")
  app$set_window_size(width = 1619, height = 953)
  app$expect_values(
    input = TRUE,
    output = FALSE, 
    export = TRUE
  )
})

test_that("{shinytest2} recording: test_abc_wohnungen", {
  app <- AppDriver$new(name = "test_abc_wohnungen", height = 1073, width = 1619)
  app$set_inputs(`input_module-address` = "Langstrasse 192")
  app$click("ActionButtonId")
  app$set_window_size(width = 1619, height = 1073)
  app$expect_values(input = TRUE,
                    output = FALSE, 
                    export = TRUE)
})


test_that("{shinytest2} recording: ungültige Strasse", {
  app <- AppDriver$new(name = "ungültige Strasse", height = 1073, width = 1619)
  app$set_inputs(`input_module-address` = "babystrasse 98")
  app$click("ActionButtonId")
  app$expect_values(input = TRUE,
                    output = FALSE, 
                    export = TRUE)
})
