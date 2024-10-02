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
    sszAutocompleteInput(
      ns("address"),
      "Geben Sie eine Adresse ein",
      df_main$df_unique_addresses
    )
  )
}

#' input Server Functions
#'
#' @noRd
mod_input_server <- function(id) {  
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Filter Data
    filtered_building <- reactive({
      req(input$address)  # Ensure address is selected
      df_main[["df_building"]] |> 
        filter(Adresse == input$address)
    })
    
    filtered_apartment <- reactive({
      req(input$address)  # Ensure address is selected
      df_main[["df_apartment"]] |>
        filter(Adresse == input$address)
    })
    
    return(list(
      "filtered_building" = filtered_building,
      "filtered_apartment" = filtered_apartment
    ))
  })
}

## To be copied in the UI
# mod_input_ui("input_module")

## To be copied in the server
# mod_input_server("input_module", data)