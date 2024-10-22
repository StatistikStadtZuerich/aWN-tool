# Test for mod_input_ui
test_that("UI: mod_input_ui creates correct input fields", {
  ui <- mod_input_ui("input_module")
  
  # Check if UI is a valid Shiny tag list
  expect_s3_class(ui, "shiny.tag.list")
  
  # Check that the UI contains the input field for address
  expect_true(any(grepl("address", as.character(ui))))
})

test_that("Server: mod_input_server filters data correctly", {

  test_address <- df_main$df_unique_addresses[1]  # Take the first address for the test
  
  # Mock session for testing the module server
  testServer(mod_input_server, args = list(id = "input_module"), {
    # Set the address input to the test address
    session$setInputs(address = test_address)

    # Check that the filtering is correct for the selected address (case insensitive)
    test_address_lower <- tolower(test_address)
    expect_equal(nrow(filtered_building()), sum(tolower(df_main$df_building$Adresse) == test_address_lower))
    expect_equal(tolower(filtered_building()$Adresse), rep(test_address_lower, nrow(filtered_building())))
    
    expect_equal(nrow(filtered_apartment()), sum(tolower(df_main$df_apartment$Adresse) == test_address_lower))
    expect_equal(tolower(filtered_apartment()$Adresse), rep(test_address_lower, nrow(filtered_apartment())))
  })
})

test_that("Server: mod_input_server handles case insensitivity in address input", {
  # Load dataset

  test_address <- df_main$df_unique_addresses[22]  # Take the 22. address for the test
  
  # Mock session for testing the module server
  testServer(mod_input_server, args = list(id = "input_module"), {
    # Set the address input to an uppercase version of the test address
    session$setInputs(address = toupper(test_address))
    
    # Check that the filtering is correct for the selected address (case insensitive)
    test_address_lower <- tolower(test_address)
    expect_equal(nrow(filtered_building()), sum(tolower(df_main$df_building$Adresse) == test_address_lower))
    expect_equal(tolower(filtered_building()$Adresse), rep(test_address_lower, nrow(filtered_building())))
    
    expect_equal(nrow(filtered_apartment()), sum(tolower(df_main$df_apartment$Adresse) == test_address_lower))
    expect_equal(tolower(filtered_apartment()$Adresse), rep(test_address_lower, nrow(filtered_apartment())))
  })
})

test_that("Server: mod_input_server handles non-existent address input", {
  # Load dataset

  non_existent_address <- "gugusstrasse 23"
  
  # Mock session for testing the module server
  testServer(mod_input_server, args = list(id = "input_module"), {
    # Set the address input to a non-existent address
    session$setInputs(address = non_existent_address)
    
    
    
    # Check that no rows are returned for a non-existent address
    expect_equal(nrow(filtered_building()), 0)
    expect_equal(nrow(filtered_apartment()), 0)
  })
})
