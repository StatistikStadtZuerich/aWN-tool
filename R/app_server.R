#' The application server-side
#'
#' @param input, output, session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  # Load data from the utility script
  data <- get_data()  
  
  # Call the input module server function
  input_data <- mod_input_server("input_module", data)
  
  # Observe the Abfrage button click event
  observeEvent(input_data$load_data_trigger(), {
    print("Abfrage button clicked")  # Debugging: Check if button is clicked
    
    # Check if an address is selected
    selected_address <- input_data$selected_address()
    print(paste("Selected address:", selected_address))
    
    req(selected_address)
    
    # Filter building based on the selected address
    selected_building <- data$building_info %>%
      filter(Address == selected_address)
    
    # Debugging log
    print("Filtered Building Info:")
    print(selected_building)
    
    if (nrow(selected_building) == 0) {
      showNotification("Keine Gebäudeinformationen verfügbar.", type = "error")
      return(NULL)
    }
    
    # Render building information
    output$building_info <- renderUI({
      tagList(
        p(paste("Gebäudetyp:", selected_building$GKLASLang)),
        p(paste("Baujahr:", selected_building$GBAUJ)),
        p(paste("Oberirdische Geschosse:", selected_building$GASTW)),
        p(paste("Unterirdische Geschosse:", selected_building$GAZZI)),
        p(paste("Zivilschutzraum:", selected_building$GSCHUTZRLang))
      )
    })
    
    # Render entrance information
    output$entrance_info <- renderUI({
      tagList(
        p(paste("Wärmeerzeuger Heizung:", selected_building$GWAERZH1Lang)),
        p(paste("Energiequelle Heizung:", selected_building$GENH1Lang)),
        p(paste("Wärmeerzeuger Warmwasser:", selected_building$GWAERZW1Lang)),
        p(paste("Energiequelle Warmwasser:", selected_building$GENW1Lang))
      )
    })
    
    # Filter apartment information based on the selected building's EGID
    selected_apartments <- data$apartment_info %>%
      filter(EGID == selected_building$EGID)
    
    print("Filtered Apartment Info:")
    print(selected_apartments)
    
    # Conditionally render the apartment table only if data is available
    if (nrow(selected_apartments) > 0) {
      output$apartment_table <- renderTable({
        selected_apartments %>%
          select(WHGNR, EWID, WSTWKLang, WBEZ, WAZIM, WAREA, WKCHELang) %>%
          rename(`Amtl. Wohnungsnummer` = WHGNR,
                 `EWID` = EWID,
                 `Stockwerk` = WSTWKLang,
                 `Lage Wohnung`=WBEZ,
                 `Zimmer` = WAZIM,
                 `Wohnfläche (m2)` = WAREA,
                 `Küchenausstattung` = WKCHELang)
      })
    } else {
      output$apartment_info <- renderUI({
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

