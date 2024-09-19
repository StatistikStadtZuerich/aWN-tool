#' download UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_download_ui <- function(id) {
  ns <- NS(id)
  tagList(
    downloadButton(ns("csvDownload"), "Download CSV"),
    downloadButton(ns("excelDownload"), "Download Excel")
  )
}

    
#' download Server Functions
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param building_data The filtered building data to be downloaded.
#' @param apartment_data The filtered apartment data to be downloaded.
#' @noRd 
mod_download_server <- function(id, building_data, apartment_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Prepare the data for download, filtering based on the displayed content
    data_for_download <- reactive({
      building_info <- building_data() %>%
        select(Address, EGID, GKLASLang, GBAUJ, GASTW, GAZZI, GSCHUTZRLang, GWAERZH1Lang, GENH1Lang, GWAERZW1Lang, GENW1Lang)
      
      apartment_info <- apartment_data() %>%
        select(WHGNR, EWID, WSTWKLang, WAZIM, WAREA, WKCHELang)
      
      # Combine the building and apartment data
      list(
        Building_Info = building_info,
        Apartment_Info = apartment_info
      )
    })
    
    
    # Get the selected address to use in the filename
    address_for_filename <- reactive({
      address <- building_data()$Address[1]  # Get the selected address
      gsub(" ", "_", address) 
    })
    
    # CSV Download
    output$csvDownload <- downloadHandler(
      filename = function() {
        paste0( address_for_filename(), "_", Sys.Date(), ".csv")
      },
      content = function(file) {
        data_to_save <- data_for_download()$Building_Info  # Get the building info
        write.csv(data_to_save, file, row.names = FALSE, na = "")
      }
    )
    
    # Excel Download
    output$excelDownload <- downloadHandler(
      filename = function() {
        paste0(address_for_filename(), "_", Sys.Date(), ".xlsx")
      },
      content = function(file) {
        building_info <- data_for_download()$Building_Info  # Get the building info
        apartment_info <- data_for_download()$Apartment_Info  # Get the apartment info
        
        # Write each sheet to the Excel file
        writexl::write_xlsx(list(Building_Info = building_info, Apartment_Info = apartment_info), file)
      }
    )
  })
}
## To be copied in the UI
# mod_download_ui("download_1")

## To be copied in the server
# mod_download_server("download_1", building_data, apartment_data)