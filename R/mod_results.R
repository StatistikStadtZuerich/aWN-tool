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
    
    # UI output for multiple entrances (only displayed when applicable)
    uiOutput(ns("entrance_info")),  # Add this line to include entrance info UI
    
    # Reactable Output with Apartment Infos
    uiOutput(ns("id_table"))
  )
}

#' results Server Functions
#' @param building_data data frame to be shown in bslib card with building_info
#' @param entrance_data data frame to be shown in additional reactable, reactive
#' @param apartment_data data frame to be shown in main reactable, reactive
#'
#' @noRd 
mod_results_server <- function(id, building_data, apartment_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Building Infos
    output$building_info <- renderUI({
      get_card(
        dataset = building_data(),
        height = 300,
        card_min_height = 200,
        card_width = 1 / 2
      )
    })
    
    # Check for multiple entrances (i.e., multiple EDIDs for the same EGID)
    observeEvent(building_data(), {
      req(building_data())
      
      # Get the EGID of the selected building address
      selected_egid <- building_data()$EGID[1]
      selected_address <- building_data()$Address[1]
      
    
      
      # Filter building data to get all entries with the same EGID
      building_multiple_entries <- df_main[["df_building"]] %>%
        filter(EGID == selected_egid)
      
      # Exclude the selected address
      entrances_to_show <- building_multiple_entries %>%
        filter(Address != selected_address)
      
      # Check if there are multiple entrances (distinct EDIDs)
      if (n_distinct(entrances_to_show$EDID) > 1) {
        # If multiple entrances exist for the building, show the additional card for entrances
        output$entrance_info <- renderUI({
          tagList(
            h4("Dieses Gebäude hat mehrere Eingänge mit unterschiedlichen Adressen."),
            p("Wenn Sie Wohnungsinformationen zu einem der untenstehenden Eingängen suchen, geben Sie diese Adresse ins Suchfeld links ein."),
            bslib::card(
              full_screen = TRUE,
              bslib::card_body(
                reactableOutput(ns("multiple_entrances_table"))  
              )
            )
          )
        })
        
        output$multiple_entrances_table <- renderReactable({
          reactable(
            entrances_to_show  %>%
              select( Address) %>%
              rename(`Adresse` = Address),
            columns = list(
              `Adresse` = colDef(name = "Weitere Eingänge")
            ),
            highlight = TRUE,
            bordered = TRUE,
            striped = TRUE,
            resizable = TRUE
          )
        })
      } else {
        # If no multiple entrances, clear the entrance info UI
        output$entrance_info <- renderUI({
          NULL
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
        output$id_table <- renderUI({
          tagList(
            h3("Informationen zu den Wohnungen"),
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
          )
        })
      } else {
        # Render a blank table or a message when no apartments are found
        output$id_table <- renderText({
          "In diesem Gebäude gibt es keine Wohnungen."
        })
      }
    })
  })
}