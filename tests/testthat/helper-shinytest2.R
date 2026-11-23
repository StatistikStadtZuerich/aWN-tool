# reactable stores a hash ("dataKey") of its data and columns definitions.
# the hash differs between devtools::test() (load_all()) and devtools::check() (installed package) although the table content is identical
# replace has with fixec placeholder before comparing snapshots
fix_reactable_key <- function(lines) {
  gsub('(dataKey\\\\?"\\s*:\\s*\\\\?")[0-9a-f]{32}', "\\1<hash>", lines)
}

# Start the aWN app in a headless Chrome browser
start_awn_app <- function(name, height = 953) {
  shinytest2::AppDriver$new(
    app_dir = run_app,
    name = name,
    seed = 123,
    height = height,
    width = 1619
  )
}

# Enter an address, click the button and wait until the app is idle
query_address <- function(app, address) {
  app$set_inputs(`input_module-address` = address)
  app$click("ActionButtonId")
  app$wait_for_idle()
  invisible(app)
}