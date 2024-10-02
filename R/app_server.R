#' The application server-side
#'
#' @param input, output, session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  # Input Module returns filtered Data
  filtered_input <- mod_input_server("input_module")

  
  # Result Module
  mod_results_server(
    "results_1",
    building_data = filtered_input$filtered_building,
    apartment_data = filtered_input$filtered_apartment
  )
  
  # Download Module
  mod_download_server(
    "download_1",
    building_data = filtered_input$filtered_building,
    apartment_data = filtered_input$filtered_apartment,
    fct_create_excel = ssz_download_excel
  )
}