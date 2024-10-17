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

  # Reactive value to control visibility of results
  show_results <- reactiveVal(FALSE)

  # Conditionally render the results module and hide the spinner
  observeEvent(input$ActionButtonId, {
    # req(filtered_building_event(), filtered_apartment_event())  # Ensure both events have been triggered

    if (nrow(filtered_input$filtered_building()) > 0) {
      print(paste0("Gültige Adresse: ", filtered_input$filtered_building()$Adresse))

      # Hide warning message when address is valid
      output$warning <- renderUI({
        NULL
      })

      # Set reactive value to show results
      show_results(TRUE)

      # Render results server only when data is available
      mod_results_server(
        "results_1",
        building_data = filtered_input$filtered_building,
        apartment_data = filtered_input$filtered_apartment
      )

      # Download module rendering
      mod_download_server(
        "download_1",
        building_data = filtered_input$filtered_building,
        apartment_data = filtered_input$filtered_apartment,
        fct_create_excel = ssz_download_excel
      )
    } else {
      print(paste0("Ungültige Adresse: ", filtered_input$selected_address()))

      # Render a warning message when address is invalid
      output$warning <- renderUI({
        get_warning()
      })

      # Hide results and download modules
      show_results(FALSE) # Set reactive value to hide results
    }

    # Hide spinner after modules are rendered
    show_spinner(FALSE)

    # Update the Action Button
    updateActionButton(session,
      "ActionButtonId",
      label = "Erneute Abfrage"
    )
  })

  # Render the UI conditionally based on the spinner's state
  output$results_ui <- renderUI({
    if (!show_spinner() && show_results()) {
      # Show the actual results UI when spinner is hidden and results are available
      mod_results_ui("results_1")
    } else {
      NULL # Do not render results if no data or spinner is active
    }
  })

  # Conditionally render the download module when the results are ready / spinner is off
  output$download_ui <- renderUI({
    if (!show_spinner() && show_results()) {
      mod_download_ui("download_1") # Display the download module UI when results are shown
    } else {
      NULL # Do not display download UI when no results
    }
  })
}
