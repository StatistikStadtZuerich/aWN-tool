test_that("test get data", {
  df_main <- get_data()
  
  # Check that the result is a list
  expect_type(df_main, "list")
  
  # check list length and names
  expect_named(df_main, c("df_building", "df_apartment", "df_unique_addresses", "df_time_stamp"))
  
  # Check that the list contains tibbles for buildings, apartments, and unique addresses
  expect_s3_class(df_main$df_building, "data.frame")
  expect_s3_class(df_main$df_apartment, "data.frame")
  expect_type(df_main$df_unique_addresses, "character")
  expect_type(df_main$df_time_stamp, "character")
  
  # Calculate the number of NAs in the awn column
  num_na_awn <- sum(is.na(df_main$df_apartment$awn))
  
  # Ensure all EGID values in df_apartment exist in df_building 
  existing_apartments <- df_main$df_apartment |>
    filter(WSTAT == 3004)
  
  inconstruction_apartments <- df_main$df_apartment |>
    filter(WSTAT == 3003)
  missing_egids <- setdiff(inconstruction_apartments$EGID, df_main$df_building$EGID)
  
  # Identify which EGIDs are not present in the building dataset
  missing_egids <- setdiff(inconstruction_apartments$EGID, df_main$df_building$EGID)
  
  # Count how many EGIDs are missing
  missing_count <- length(missing_egids)
  
  # Filter the in-construction apartments with missing EGIDs --> reason: gstat is 1004
  missing_apartments <- inconstruction_apartments |>
    filter(EGID %in% missing_egids)
  
  
  # Output the result
  print(paste("Number of missing EGIDs:", missing_count))
  print("List of missing EGIDs:")
  print(missing_egids)
  expect_true(all(existing_apartments$EGID %in% df_main$df_building$EGID)) 

  
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