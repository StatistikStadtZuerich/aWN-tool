#' The application server-side
#'
#' @param input, output, session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  # Call the input module server function
  input_data <- mod_input_server("input_module", data)
  
  # Call the output module
  # mod_building_server(id = "asdf")
  
  # TEMPORARY OUTPUTS BEFORE MODULARIZATION
  observeEvent(input_data$load_data_trigger(), {
    print("Abfrage button clicked")  # Debugging: Check if button is clicked
    
    # Check if an address is selected
    selected_address <- input_data$selected_address()
    print(paste("Selected address:", selected_address))
    
    # Filter building based on the selected address
    req(selected_address)
    selected_building <- data$building_info %>%
      filter(Address == selected_address)
    print(paste("Filtered Building Info:", selected_building[1]))
    
    if (nrow(selected_building) == 0) {
      showNotification("Keine Gebäudeinformationen verfügbar.", type = "error")
      return(NULL)
    }
    
    # Render building information
    output$building_info <- renderUI({
      bslib::card(
        height = 350,
        full_screen = TRUE,
        bslib::card_header(h4(paste("Informationen zum Gebäude mit EGID:", selected_building$EGID))),
        card_body(
          min_height = 200,
          layout_column_wrap(
            width = 1/2,
            tagList(
              h4("Allgemeine Informationen"),
              p(paste("Gebäudetyp:", selected_building$GKLASLang)),
              p(paste("Baujahr:", selected_building$GBAUJ)),
              p(paste("Oberirdische Geschosse:", selected_building$GASTW)),
              p(paste("Unterirdische Geschosse:", selected_building$GAZZI)),
              p(paste("Zivilschutzraum:", selected_building$GSCHUTZRLang))
            ),
            tagList(
              h4("Heizung & Wasser"),
              p(paste("Wärmeerzeuger Heizung:", selected_building$GWAERZH1Lang)),
              p(paste("Energiequelle Heizung:", selected_building$GENH1Lang)),
              p(paste("Wärmeerzeuger Warmwasser:", selected_building$GWAERZW1Lang)),
              p(paste("Energiequelle Warmwasser:", selected_building$GENW1Lang)),
              p(paste("EGID:", selected_building$EGID))
            )
          )
        )
      )
    })
    
    # Filter apartment information based on the selected building's EGID
    selected_apartments <- data$apartment_info %>%
      filter(EGID == selected_building$EGID) %>%
      mutate(awn = as.numeric(WHGNR)) %>%
      
      # Create the "corrected aWN" column the output should be sorted from 2.UG to its highest floor
      mutate(aWN_korrigiert = ifelse(awn >= 9800 & awn <= 9999, awn - 10000, awn)) %>%
      # Sort by the corrected aWN column
      arrange(aWN_korrigiert)
    
    print("Filtered Apartment Info:")
    print(selected_apartments)
    
    # Conditionally render the apartment table only if data is available
    if (nrow(selected_apartments) > 0) {
      h4("Informationen zu Wohnungen")
      output$apartment_table <- renderTable({
        # Check if WBEZ exists in the dataset
        if ("WBEZ" %in% names(selected_apartments)) {
          selected_apartments %>%
            select(WHGNR, EWID, WSTWKLang, WBEZ, WAZIM, WAREA, WKCHELang) %>%
            rename(`Amtl. Wohnungsnummer` = WHGNR,
                   `EWID` = EWID,
                   `Stockwerk` = WSTWKLang,
                   `Lage Wohnung` = WBEZ,
                   `Zimmer` = WAZIM,
                   `Wohnfläche (m2)` = WAREA,
                   `Küchenausstattung` = WKCHELang)
        } else {
          selected_apartments %>%
            select(WHGNR, EWID, WSTWKLang, WAZIM, WAREA, WKCHELang) %>%
            rename(`Amtl. Wohnungsnummer` = WHGNR,
                   `EWID` = EWID,
                   `Stockwerk` = WSTWKLang,
                   `Zimmer` = WAZIM,
                   `Wohnfläche (m2)` = WAREA,
                   `Küchenausstattung` = WKCHELang)
        }
      })
    } else {
      output$apartment_info <- renderUI({
        h4("Informationen zu Wohnungen")
        p("Keine Wohnungsinformationen verfügbar.")
      })
    }
  })
  
  # Download Handlers for data export
  output$download_csv <- downloadHandler(
    filename = function() {
      paste("building_data", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      selected_building <- data$building_info %>%
        filter(Address == input_data$selected_address())
      write.csv(selected_building, file, row.names = FALSE)
    }
  )
  
  output$download_excel <- downloadHandler(
    filename = function() {
      paste("building_data", Sys.Date(), ".xlsx", sep = "")
    },
    content = function(file) {
      selected_building <- data$building_info %>%
        filter(Address == input_data$selected_address())
      writexl::write_xlsx(selected_building, file)
    }
  )
  
  output$download_ogd <- downloadHandler(
    filename = function() {
      paste("building_data", Sys.Date(), ".ogd", sep = "")
    },
    content = function(file) {
      selected_building <- data$building_info %>%
        filter(Address == input_data$selected_address())
      write.csv(selected_building, file, row.names = FALSE)
    }
  )
}

