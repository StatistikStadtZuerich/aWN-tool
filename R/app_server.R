#' The application server-side
#'
#' @param input, output, session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Input Module returns filtered Data
  filtered_input <- mod_input_server("input_module")

  # Reactive value to control visibility of results and download
  show_results <- reactiveVal(FALSE)

  # Conditionally render the results and download modules
  observeEvent(input$ActionButtonId, {

    if (nrow(filtered_input$filtered_building()) > 0) {

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
      invalid_address <- filtered_input$selected_address()

      # Render a warning message when address is invalid
      output$warning <- renderUI({
        sszWarningBox(
          title = "Ungültige Adresseingabe",
          text = paste0("Die Adresse «", invalid_address, "» existiert nicht."),
          icon = ssz_icons()("important-warning-filled")
        )
      })

      # Hide results and download modules
      show_results(FALSE)
    }

    # Update the Action Button
    updateActionButton(session,
      "ActionButtonId",
      label = "Erneute Abfrage"
    )
  })

  # Expose show_results to the client so conditionalPanel can react to it
  output$show_results <- reactive({
    show_results()
  })
  outputOptions(output, "show_results", suspendWhenHidden = FALSE)
}
