# Test for mod_input_ui
test_that("UI: mod_input_ui creates correct input fields", {
  ui <- mod_input_ui("input_module")
  
  # Check if UI is a valid Shiny tag list
  expect_s3_class(ui, "shiny.tag.list")
  
  # Check that the UI contains the input field for address
  expect_true(any(grepl("address", as.character(ui))))
})

test_that("Server: mod_input_server filters data correctly", {
  # Load dataset
  df_main <- get_data()  
  
  test_address <- df_main$df_unique_addresses[1]  # Take the first address for the test
  
  # Mock session for testing the module server
  testServer(mod_input_server, args = list(id = "input_module"), {
    # Set the address input to the test address
    session$setInputs(address = test_address)
    
    # Test reactive filtering logic
    filtered_building <- filtered_building()  # Reactive output
    filtered_apartment <- filtered_apartment()  # Reactive output
    
    # Print the filtered results for debugging purposes
    print("Filtered Building Data:")
    print(filtered_building)
    
    print("Filtered Apartment Data:")
    print(filtered_apartment)
    
    # Check that the filtering is correct for the selected address
    expect_equal(nrow(filtered_building), sum(df_main$df_building$Adresse == test_address))
    expect_equal(filtered_building$Adresse, rep(test_address, nrow(filtered_building)))
    
    expect_equal(nrow(filtered_apartment), sum(df_main$df_apartment$Adresse == test_address))
    expect_equal(filtered_apartment$Adresse, rep(test_address, nrow(filtered_apartment)))
  })
})