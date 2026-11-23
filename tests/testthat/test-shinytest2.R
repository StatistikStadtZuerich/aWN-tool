test_that("{shinytest2} awn-tool starting values", {
  skip_on_cran()
  app <- start_awn_app("awn-tool")
  withr::defer(app$stop())
  
  query_address(app, "Verenastrasse 16")
  
  app$expect_values(transform = fix_reactable_key)
})

test_that("{shinytest2} floors are sorted correctly", {
  skip_on_cran()
  app <- start_awn_app("test_sorting_floor_correctly")
  withr::defer(app$stop())
  
  query_address(app, "Zähringerstrasse 27")
  
  app$expect_values(transform = fix_reactable_key)
})

test_that("{shinytest2} building with many apartments (abc numbering)", {
  skip_on_cran()
  app <- start_awn_app("test_abc_wohnungen", height = 1073)
  withr::defer(app$stop())
  
  query_address(app, "Langstrasse 192")
  
  app$expect_values(transform = fix_reactable_key)
})

test_that("{shinytest2} invalid address", {
  skip_on_cran()
  app <- start_awn_app("ungueltig", height = 1073)
  withr::defer(app$stop())
  
  query_address(app, "babystrasse 98")
  
  app$expect_values(transform = fix_reactable_key)
})