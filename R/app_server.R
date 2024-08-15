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
  
  # Use selected address and load_data status
  observeEvent(input_data$load_data_trigger(), {
    req(input_data$selected_address())
    
    selected_building <- data$building_info %>%
      filter(Address == input_data$selected_address())
    
    selected_apartments <- data$apartment_info %>%
      filter(EGID == selected_building$EGID)
    
    # Display selected address
    output$selected_address <- renderText({
      input_data$selected_address()
    })
    
    # Render building information
    output$building_info <- renderUI({
      if (nrow(selected_building) > 0) {
        tagList(
          p(paste("Gebäudetyp:", selected_building$GKLASLang)),
          p(paste("Baujahr:", selected_building$GBAUJ)),
          p(paste("Oberirdische Geschosse:", selected_building$GASTW)),
          p(paste("Unterirdische Geschosse:", selected_building$GAZZI)),
          p(paste("Zivilschutzraum:", selected_building$GSCHUTZRLang))
        )
      } else {
        p("Keine Gebäudeinformationen verfügbar.")
      }
    })
    
    # Render entrance information
    output$entrance_info <- renderUI({
      if (nrow(selected_building) > 0) {
        tagList(
          p(paste("Wärmeerzeuger Heizung:", selected_building$GWAERZH1Lang)),
          p(paste("Energiequelle Heizung:", selected_building$GENH1Lang)),
          p(paste("Wärmeerzeuger Warmwasser:", selected_building$GWAERZW1Lang)),
          p(paste("Energiequelle Warmwasser:", selected_building$GENW1Lang))
        )
      } else {
        p("Keine Informationen zu Heizung und Wasser verfügbar.")
      }
    })
    
    # Render apartment information
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
      write.csv(data$building_info, file, row.names = FALSE)
    }
  )
  
  output$download_excel <- downloadHandler(
    filename = function() {
      paste("building_data", Sys.Date(), ".xlsx", sep = "")
    },
    content = function(file) {
      writexl::write_xlsx(data$building_info, file)
    }
  )
  
  output$download_ogd <- downloadHandler(
    filename = function() {
      paste("building_data", Sys.Date(), ".ogd", sep = "")
    },
    content = function(file) {
      write.csv(data$building_info, file, row.names = FALSE)
    }
  )
}

