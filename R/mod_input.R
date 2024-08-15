#' input UI Function
#'
#' @description A shiny Module for the address and data selection inputs.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_input_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Select input for address
    selectInput(ns("address"), "Select Address", choices = NULL),  # Choices will be populated in the server
    
    # Button to load data
    actionButton(ns("load_data"), "Daten herunterladen"),
    
    # "Abfrage" action button
    actionButton(ns("abfrage"), "Abfrage", class = "btn-primary")
  )
}

#' input Server Functions
#'
#' @noRd
mod_input_server <- function(id, data) {  
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Debugging: Print to check if the values are being captured
    observe({
      print(paste("Address selected:", input$address))
      print(paste("Load data button clicked:", input$load_data))
    })
    
    # Populate the address dropdown with sorted addresses
    updateSelectizeInput(session, "address",
                         choices = data$building_info$Address,
                         server = TRUE)
    
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


