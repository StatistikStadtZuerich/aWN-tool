#' The application server-side
#'
#' @param input, output, session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinyjs
#' @noRd
app_server <- function(input, output, session) {
  # Input Module returns filtered Data
  filtered_input <- mod_input_server("input_module")

  # Conditionally render the results and download modules
  observeEvent(input$ActionButtonId, {

    if (nrow(filtered_input$filtered_building()) > 0) {

      # Hide warning, show results and download
      output$warning <- renderUI(NULL)
      show("results_wrapper")
      show("download_wrapper")

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
          icon = icons_stzh()("important-warning-filled")
        )
      })

      # Hide results and download
      hide("results_wrapper")
      hide("download_wrapper")
    }

    # Update the Action Button
    updateActionButton(session,
      "ActionButtonId",
      label = "Erneute Abfrage"
    )
  })
}
