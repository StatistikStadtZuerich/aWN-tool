#' result_address UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_result_address_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' result_address Server Functions
#'
#' @noRd 
mod_result_address_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_result_address_ui("result_address_1")
    
## To be copied in the server
# mod_result_address_server("result_address_1")
