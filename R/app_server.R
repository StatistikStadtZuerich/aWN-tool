#' The application server-side
#'
#' @param input, output, session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  # Input Module returns filtered Data
  filtered_input <- mod_input_server("input_module")
  
  # Reactive values to track the current and previous selected addresses
  current_selected_address <- reactiveVal("")    # Store the current selected address
  previous_selected_address <- reactiveVal("")   # Store the previous selected address
  address_changed <- reactiveVal(FALSE)          # Track if the address has changed
  
  # Reactive value to track whether the Action Button was clicked after the address changed
  action_button_clicks <- reactiveVal(0)         # Track action button click count
  
  ## Observe address changes
  observeEvent(input$`input_module-address`, {
    current_address <- input$`input_module-address`
    
    # If the current address differs from the previous one, reset action state
    if (current_address != previous_selected_address()) {
      previous_selected_address(current_selected_address())  # Store the previous selected address
      current_selected_address(current_address)              # Update to the new current address
      address_changed(TRUE)                                  # Mark the address as changed
      action_button_clicks(0)                                # Reset the button click count
      cat("Address changed to:", current_address, "\n")
      cat("Number of clicks reset to:", action_button_clicks(), "\n")
    } else {
      address_changed(FALSE)                                 # Mark as unchanged if the address hasn't changed
    }
  })
  
  ## Observe Action Button clicks
  observeEvent(input$ActionButtonId, {
    # Increment the button click count
    action_button_clicks(action_button_clicks() + 1)
    cat("Actcion button clicked:", action_button_clicks(), "times\n")
    
    # Only update the result module if the address has changed
    if (address_changed() == TRUE) {
      # Call the result module with new data here
      mod_results_server(
        "results_1",
        building_data = filtered_input$filtered_building,
        apartment_data = filtered_input$filtered_apartment
      )
      
      # Reset address changed flag after processing
      address_changed(FALSE)                              # Mark the address as processed
      cat("Results updated for address:", current_selected_address(), "\n")
      
    } else {
      cat("Action Button clicked but no address change detected.\n")
    }
  })
}