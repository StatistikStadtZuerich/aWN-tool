test_that("test get data", {
  df_main <- get_data()
  
  # Check that the result is a list
  expect_type(df_main, "list")
  
  # check list length and names
  expect_named(df_main, c("df_building", "df_apartment", "df_unique_addresses"))
  
  # Check that the list contains tibbles for buildings, apartments, and unique addresses
  expect_s3_class(df_main$df_building, "data.frame")
  expect_s3_class(df_main$df_apartment, "data.frame")
  expect_type(df_main$df_unique_addresses, "character")
  
  # Calculate the number of NAs in the awn column
  num_na_awn <- sum(is.na(df_main$df_apartment$awn))
  
  # Ensure all EGID values in df_apartment exist in df_building
  expect_true(all(df_main$df_apartment$EGID %in% df_main$df_building$EGID))
  
  # Check that df_apartement contains specific columns
  expect_true(all(c("EGID", "aWN", "EWID", "Stockwerk", "Zimmer", "Wohnfläche (m2)", "Küche") %in% names(df_main$df_apartment)))
  
  # Check that df_building contains specific columns
  expect_true(all(c("EGID", "STRNAME", "DEINR", "Baujahr", "Gebäudetyp") %in% names(df_main$df_building)))
  
  expect_false(any(is.na(df_main$df_building$EGID)))
  
  expect_false(any(is.na(df_main$df_building$aWN)))
  
  # Check after removing "Wohnung" from WHGNR; aWN and WHGNr shouldn't have the prefix Wohnung
  expect_equal(sum(stringr::str_detect(df_main$df_apartment$aWN, "Wohnung")), 0)
  expect_equal(sum(stringr::str_detect(df_main$df_apartment$WHGNR, "Wohnung")), 0)
  
  # Check that there are at least 40,000 EGID entries in the building dataset
  expect_gt(nrow(df_main$df_building), 40000)
  
  # Check that there are at least 200,000 aWN entries in the apartment 
  expect_gt(nrow(df_main$df_apartment), 200000)
  
  
})