library(shinytest2)

test_that("{shinytest2} recording: awn-tool starting values", {
  skip_on_cran()
  app <- AppDriver$new(
    app_dir = run_app,
    seed = 123,
    name = "awn-tool",
    height = 953,
    width = 1619
  )
  app$set_inputs(`input_module-address` = "Verenastrasse 16")
  # after click, wait until everything is ready/idle
  app$wait_for_idle()
  app$click("ActionButtonId")
  app$wait_for_idle()
  app$expect_values()
})

test_that("{shinytest2} recording: test_sorting_floor_correctly", {
  skip_on_cran()
  app <- AppDriver$new(
    app_dir = run_app,
    name = "test_sorting_floor_correctly",
    seed = 123,
    height = 953,
    width = 1619
  )
  app$set_inputs(`input_module-address` = "Zähringerstrasse 27")
  app$wait_for_idle()
  app$click("ActionButtonId")
  # after click, wait until everything is ready/idle
  app$wait_for_idle()
  app$expect_values()
})

test_that("{shinytest2} recording: test_abc_wohnungen", {
  skip_on_cran()
  app <- AppDriver$new(
    app_dir = run_app,
    name = "test_abc_wohnungen",
    seed = 123,
    height = 1073,
    width = 1619
  )
  app$set_inputs(`input_module-address` = "Langstrasse 192")
  app$wait_for_idle()
  app$click("ActionButtonId")
  # after click, wait until everything is ready/idle
  app$wait_for_idle()
  app$expect_values()
})

test_that("{shinytest2} recording: ungueltig", {
  skip_on_cran()
  app <- AppDriver$new(
    app_dir = run_app,
    name = "ungueltig",
    seed = 123,
    height = 1073,
    width = 1619
  )
  app$set_inputs(`input_module-address` = "babystrasse 98")
  app$wait_for_idle()
  app$click("ActionButtonId")
  # after click, wait until everything is ready/idle
  app$wait_for_idle()
  app$expect_values()
})
