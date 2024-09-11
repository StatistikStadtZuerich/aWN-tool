#' results UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_results_ui <- function(id) {
  ns <- NS(id)
  tagList(

    # Card with Building Infos
    uiOutput(ns("building_info")),
    
    # Reactable Output with Apartment Infos (still wrong data frame)
    reactableOutput(ns("id_table"))
  )
}

#' results Server Functions
#' @param building_data data frame to be shown in bslib card with building_info
#' @param entrance_data data frame to be shown in additional reactable, reactive
#' @param apartment_data data frame to be shown in main reactable, reactive
#'
#' @noRd 
mod_results_server <- function(id, building_data, apartment_data){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    # Building Infos
    output$building_info <- renderUI({
      get_card(dataset = building_data(), 
               height = 300, 
               card_min_height = 200, 
               card_width = 1/2)
    })
    
    # Check if the selected building has multiple addresses (multiple EDIDs for the same EGID)
    observeEvent(building_data(), {
      req(building_data())
      
      # Get the EGID of the selected building address
      selected_egid <- building_data()$EGID[1]
      
      # Filter building data to get all entries with the same EGID
      building_multiple_entries <- building_data() %>%
        filter(EGID == selected_egid)
      
      # Check if there are multiple EDIDs (entrances) for the same EGID
      if (n_distinct(building_multiple_entries$EDID) > 1) {
        # If multiple entrances exist for the building, show a message and list the addresses
        output$building_info <- renderUI({
          tagList(
            get_card(dataset = building_data(), 
                     height = 300, 
                     card_min_height = 200, 
                     card_width = 1/2),
            h3("Dieses Gebäude hat mehrere Eingänge mit unterschiedlichen Adressen:"),
            ul(
              lapply(unique(paste(building_multiple_entries$address, sep = " ")), function(addr) {
                li(addr)  # Display each unique entrance address
              })
            )
          )
        })
      } else {
        # If no multiple entrances, just display the standard building info card
        output$building_info <- renderUI({
          get_card(dataset = building_data(), 
                   height = 300, 
                   card_min_height = 200, 
                   card_width = 1/2)
        })
      }
    })
    
    
    # Apartment Infos
    observeEvent(apartment_data(), {
      req(apartment_data())
      
      if (nrow(apartment_data()) > 0) {
        # Sort the apartments by aWN_korrigiert (if necessary)
        sorted_apartments <- apartment_data() %>%
          mutate(awn = as.numeric(WHGNR)) %>%
          mutate(aWN_korrigiert = ifelse(awn >= 9800 & awn <= 9999, awn - 10000, awn)) %>%
          arrange(aWN_korrigiert)
        
        # Render the table if apartments are present
        output$id_table <- renderReactable({
          reactable(
            sorted_apartments %>%
              select(WHGNR, EWID, WSTWKLang, WBEZ, WAZIM, WAREA, WKCHELang, Address) %>%
              rename(
                `Amtliche Wohnungsnummer` = WHGNR,
                `EWID` = EWID,
                `Stockwerk` = WSTWKLang,
                `Lage Wohnung` = WBEZ,
                `Zimmer` = WAZIM,
                `Wohnfläche (m2)` = WAREA,
                `Küchenausstattung` = WKCHELang,
                `Adresse` = Address
              )
          )
        })
      } else {
        # Render a blank table or a message when no apartments are found
        output$id_table <- renderReactable({
          reactable(data.frame(Message = "In diesem Gebäude gibt es keine Wohnungen."))
        })
      }
    })
  })
}
    # 
    # # Apartment Infos
    # output$id_table <- renderReactable({
    #   reactable(apartment_data())
    # })
    
    # if(nrow(apartment_data()) > 0) {
    #   output$id_table <- renderReactable({
    #     reactable(apartment_data())
    #   })
    # } else {
    #   p("In diesem Gebäude gibt es keine Wohnungen.")
    # }
#   })
# }

## To be copied in the UI
# mod_result_address_ui("results_1")

## To be copied in the server
# mod_result_address_server("results_1")
