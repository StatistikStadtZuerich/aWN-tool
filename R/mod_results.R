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
    
    # Apartment Infos
    output$id_table <- renderReactable({
      reactable(apartment_data())
    })
    
    # if(nrow(apartment_data()) > 0) {
    #   output$id_table <- renderReactable({
    #     reactable(apartment_data())
    #   })
    # } else {
    #   p("In diesem Gebäude gibt es keine Wohnungen.")
    # }
  })
}

## To be copied in the UI
# mod_result_address_ui("results_1")

## To be copied in the server
# mod_result_address_server("results_1")
