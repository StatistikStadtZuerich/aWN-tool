test_that("mod_results_server renders UI correctly based on building and apartment data", {
  
  # Download the ssz_icons if not already installed
  tryCatch({
    icons::icon_set("ssz_icons")
  }, error = function(e) {
    icons::download_ssz_icons()
  })
  
  # Load real dataset
  df_main <- get_data()
  
  # Filter a building and apartments for a specific address, for example, "Verenastrasse 16"
  building_data <- df_main$df_building %>% 
    filter(Adresse == "Verenastrasse 16")
  
  apartment_data <- df_main$df_apartment %>% 
    filter(Adresse == "Verenastrasse 16")
  
  # Check if we have data for this address
  expect_true(nrow(building_data) > 0, "No building data found for Verenastrasse 16")
  expect_true(nrow(apartment_data) > 0, "No apartment data found for Verenastrasse 16")
  
  # Mock session for testing the module server
  testServer(
    mod_results_server,
    args = list(building_data = reactive({ building_data }), apartment_data = reactive({ apartment_data })),
    {
      # Check if the UI outputs are rendered correctly
      expect_true(isTruthy(output$building_info), "Building info should be rendered")
      expect_true(isTruthy(output$apartment_infos), "Apartment info should be rendered")
      
      # Check if entrance info is rendered when there are multiple entrances
      if (n_distinct(building_data$EDID) > 1) {
        expect_true(isTruthy(output$entrance_info), "Entrance info should be rendered for multiple entrances")
      } else {
        expect_false(isTruthy(output$entrance_info), "Entrance info should not be rendered for single entrance")
      }
      
      # Check if apartments in progress are correctly indicated
      apartments_in_progress <- apartment_data %>% filter(WSTAT == 3003)
      if (nrow(apartments_in_progress) > 0) {
        expect_true(isTruthy(output$apartment_infos), "Apartments in progress should be indicated")
      }
      
      # Check the timestamp rendering
      expect_true(isTruthy(output$timestamp), "Timestamp should be rendered")
    }
  )
})

