#' result_awn UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_result_awn_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' result_awn Server Functions
#'
#' @noRd 
mod_result_awn_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_result_awn_ui("result_awn_1")
    
## To be copied in the server
# mod_result_awn_server("result_awn_1")
