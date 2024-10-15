#' The application server-side
#'
#' @param input, output, session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  # Input Module returns filtered Data
  filtered_input <- mod_input_server("input_module")
  
  # Reactive to control spinner visibility
  show_spinner <- reactiveVal(TRUE) 
  
  # Reactive expression to hold filtered data, triggered by action button
  filtered_building_event <- eventReactive(input$ActionButtonId, {
    req(filtered_input$filtered_building())
    show_spinner(TRUE)  # Show the spinner when the action button is clicked
    filtered_input$filtered_building()
  })
  
  filtered_apartment_event <- eventReactive(input$ActionButtonId, {
    req(filtered_input$filtered_apartment())
    filtered_input$filtered_apartment()
  })
  
  # Conditionally render the results module and hide the spinner
  observe({
    req(filtered_building_event(), filtered_apartment_event())  # Ensure both events have been triggered
    
    # Render results server only when data is available
    mod_results_server(
      "results_1",
      building_data = filtered_building_event,
      apartment_data = filtered_apartment_event
    )
    
    # Download module rendering
    mod_download_server(
      "download_1",
      building_data = filtered_input$filtered_building,
      apartment_data = filtered_input$filtered_apartment,
      fct_create_excel = ssz_download_excel
    )
    
    # Hide spinner after modules are rendered
    show_spinner(FALSE)
    
    # Update the Action Button
    updateActionButton(session, 
                       "ActionButtonId", 
                       label = "Erneute Abfrage")
  })
  
  # Render the UI conditionally based on the spinner's state
  output$results_ui <- renderUI({
    if (!show_spinner()) {
      # Show the spinner while results are being processed (Spinner is in mod_result_ui)
      mod_results_ui("results_1")
    } else {
      # Show the actual results UI when the spinner is hidden
      NULL
    }
  })
  
  # Conditionally render the download module when the results are ready / spinner is off
  output$download_ui <- renderUI({
    if (!show_spinner()) {
      mod_download_ui("download_1")  # Display the download module UI
    } else {
      NULL  # Do not display anything until results are ready
    }
  })
}