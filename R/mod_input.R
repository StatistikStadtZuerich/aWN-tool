#' input UI Function
#'
#' @description A shiny Module for the address and data selection inputs.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_input_ui <- function(id, addresses) {
  
  ns <- NS(id)
  
  tagList(
    
    # Select input for address
    sszAutocompleteInput(
      ns("address"),
      "Geben Sie eine Adresse ein",
      unique(data$building_info$Address)
    ),
    
    # Button to load data
    sszActionButton(ns("load_data"), "Abfrage starten")
    
  )
}

#' input Server Functions
#'
#' @noRd
mod_input_server <- function(id, data) {  
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Needed for second query. We do later
    # updateSelectizeInput(session, "address",
    #                      choices = unique(data$building_info$Address),
    #                      server = TRUE)
    
    return(list(
      selected_address = reactive(input$address),
      load_data_trigger = reactive(input$load_data)
    ))
  })
}


## To be copied in the UI
# mod_input_ui("input_module")

## To be copied in the server
# mod_input_server("input_module", data)


