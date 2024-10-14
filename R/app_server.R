#' The application server-side
#'
#' @param input, output, session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  # Input Module returns filtered Data
  filtered_input <- mod_input_server("input_module")
  
  # Reactive expression to hold filtered data, triggered by action button
  filtered_building_event <- eventReactive(input$ActionButtonId, {
    req(filtered_input$filtered_building())
    filtered_input$filtered_building()
  })
  
  filtered_apartment_event <- eventReactive(input$ActionButtonId, {
    req(filtered_input$filtered_apartment())
    filtered_input$filtered_apartment()
  })
  
  # Conditionally render the results module when the button is clicked
  observe({
    req(filtered_building_event(), filtered_apartment_event())  # Ensure both events have been triggered
    mod_results_server(
      "results_1",
      building_data = filtered_building_event,
      apartment_data = filtered_apartment_event 
    )
    mod_download_server(
      "download_1",
      building_data = filtered_input$filtered_building,
      apartment_data = filtered_input$filtered_apartment,
      fct_create_excel = ssz_download_excel
    )
    
    # Update action button label after the first click
    observeEvent(input$ActionButtonId, {
      updateActionButton(session, 
                         "ActionButtonId", 
                         label = "Erneute Abfrage starten")
    })
    
  })
}