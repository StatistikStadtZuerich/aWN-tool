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
  
  # Simplified observeEvent for debugging
  observeEvent(input_data$load_data_trigger(), {
    print("Abfrage button clicked")  # Debugging: Check if button is clicked
    
    # Check if an address is selected
    print(paste("Selected address:", input_data$selected_address()))
    
    req(input_data$selected_address())
    
    # Filter building based on the selected address
    selected_building <- data$building_info %>%
      filter(Address == input_data$selected_address())
    
    # Debugging log
    print(selected_building)
    
    if (nrow(selected_building) == 0) {
      showNotification("Keine Gebäudeinformationen verfügbar.", type = "error")
      return(NULL)
    }
    
    # Render building information for debugging
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
    
    # Render apartment information
    selected_apartments <- data$apartment_info %>%
      filter(EGID == selected_building$EGID)
    
    output$apartment_info <- renderUI({
      if (nrow(selected_apartments) > 0) {
        tableOutput("apartment_table")
      } else {
        p("Keine Wohnungsinformationen verfügbar.")
      }
    })
    
    # Render apartment table
    output$apartment_table <- renderTable({
      selected_apartments %>%
        select(WHGNR, EWID, WSTWKLang, WAZIM, WAREA, WKCHELang) %>%
        rename(`Amtl. Wohnungsnummer` = WHGNR,
               `EWID` = EWID,
               `Stockwerk` = WSTWKLang,
               `Zimmer` = WAZIM,
               `Wohnfläche (m2)` = WAREA,
               `Küchenausstattung` = WKCHELang)
    })
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
