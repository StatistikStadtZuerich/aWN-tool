#' The application server-side
#'
#' @param input, output, session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  # Input Module returns filtered Data
  filtered_input <- mod_input_server("input_module")
  
  # Reactive to track whether results are ready
  results_ready <- reactiveVal(FALSE) 
  
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
    
    # Update the Action Button
    updateActionButton(session, 
                       "ActionButtonId", 
                       label = "Erneute Abfrage")
    
    # Render the Timestamp
    output$timestamp <- renderUI({
      p(paste("Stand der letzten Datenaktualisierung:", df_main[["df_time_stamp"]]))
    })
    
    # Results ready
    results_ready(TRUE)
  })
  
  # Conditionally render the download module when the results are ready
  output$download_ui <- renderUI({
    if (results_ready()) {
      mod_download_ui("download_1")  # Display the download module UI
    } else {
      NULL  # Do not display anything until results are ready
    }
  })
  
  # Initialize the download server module when results are ready
  observeEvent(results_ready(), {
    if (results_ready()) {
      mod_download_server(
        "download_1",
        building_data = filtered_input$filtered_building,
        apartment_data = filtered_input$filtered_apartment,
        fct_create_excel = ssz_download_excel
      )
    }
  })

}