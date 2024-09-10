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
    filtered_input$filtered_building,
    filtered_input$filtered_apartment
  )

  #   # Filter apartment information based on the selected building's EGID
  #   selected_apartments <- data$apartment_info %>%
  #     filter(EGID == selected_building$EGID) %>%
  #     mutate(awn = as.numeric(WHGNR)) %>%
  # 
  #     # Create the "corrected aWN" column the output should be sorted from 2.UG to its highest floor
  #     mutate(aWN_korrigiert = ifelse(awn >= 9800 & awn <= 9999, awn - 10000, awn)) %>%
  #     # Sort by the corrected aWN column
  #     arrange(aWN_korrigiert)
  # 
  #   print("Filtered Apartment Info:")
  #   print(selected_apartments)
  # 
  #   # Conditionally render the apartment table only if data is available
  #   if (nrow(selected_apartments) > 0) {
  #     h4("Informationen zu Wohnungen")
  #     output$apartment_table <- renderTable({
  #       # Check if WBEZ exists in the dataset
  #       if ("WBEZ" %in% names(selected_apartments)) {
  #         selected_apartments %>%
  #           select(WHGNR, EWID, WSTWKLang, WBEZ, WAZIM, WAREA, WKCHELang) %>%
  #           rename(`Amtl. Wohnungsnummer` = WHGNR,
  #                  `EWID` = EWID,
  #                  `Stockwerk` = WSTWKLang,
  #                  `Lage Wohnung` = WBEZ,
  #                  `Zimmer` = WAZIM,
  #                  `Wohnfläche (m2)` = WAREA,
  #                  `Küchenausstattung` = WKCHELang)
  #       } else {
  #         selected_apartments %>%
  #           select(WHGNR, EWID, WSTWKLang, WAZIM, WAREA, WKCHELang) %>%
  #           rename(`Amtl. Wohnungsnummer` = WHGNR,
  #                  `EWID` = EWID,
  #                  `Stockwerk` = WSTWKLang,
  #                  `Zimmer` = WAZIM,
  #                  `Wohnfläche (m2)` = WAREA,
  #                  `Küchenausstattung` = WKCHELang)
  #       }
  #     })
  #   } else {
  #     output$apartment_info <- renderUI({
  #       h4("Informationen zu Wohnungen")
  #       p("Keine Wohnungsinformationen verfügbar.")
  #     })
  #   }
  # })

}

