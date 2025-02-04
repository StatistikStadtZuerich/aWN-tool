#' get_data
#'
#' @description Function to read the three open government datasets on which the app is based
#'
#' @details The sources of the datasets are https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/resource/0dc7e4f2-09dd-4054-a14f-9ee8e6d5b2bb,https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/resource/22094869-a3f4-44a1-a49d-a9d7dc80253a, https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/resource/69aeb436-4718-4b56-a7b5-452f37a97147
#'
#' @return a named list of tibbles with zones, series, and addresses
#' @noRd
get_data <- function() {
  # By default data is empty
  data <- NULL

  # Specify URLS
  URLs <- c(
    "https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/download/gwr_stzh_gebaeude.csv",
    "https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/download/gwr_stzh_gebaeudeeingaenge.csv",
    "https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/download/gwr_stzh_wohnungen.csv"
  )

  # Parallelisation
  data <- furrr::future_map(URLs, \(x) data.table::fread(x, encoding = "UTF-8"))

  if (!is.null(data)) {
    ### Data Transformation

    # Assuming the structure of data corresponds to the downloaded datasets
    gebaeude <- data[[1]]
    eingang <- data[[2]]
    wohnung <- data[[3]]
    time <- format(Sys.time(), "%d.%m.%Y")

    # Filter based on yellow-highlighted variables
    filtered_gebaeude <- gebaeude |>
      filter(
        GDEKT == "ZH",
        GGDENR == 261,
        GGDENAME == "Zürich",
        GSTAT == 1004
      )

    filtered_wohnungen <- wohnung |>
      filter(WSTAT == 3004 | WSTAT == 3003)

    # Select and transform the data needed for building information
    building_with_address <- filtered_gebaeude |>
      left_join(eingang, by = "EGID") |>
      select(
        EDID, # Entrance identity
        EGID, # Unique building ID
        STRNAME, # Street Name
        DEINR, # House Number
        DPLZ4, # Postal Code
        DPLZNAME, # City
        GSTAT,
        GBAUJ, # Building year
        GKLASLang, # Building class
        GASTW, # Number of floors
        GSCHUTZRLang, # Civil protection room
        GWAERZH1Lang, # Heating system 1
        GENH1Lang, # Energy source 1
        GWAERZH2Lang, # Heating system 2
        GENH2Lang, # Energy source 2
        GWAERZW1Lang, # Warm water generator 1
        GENW1Lang, # Energy source warm water 1
        GWAERZW2Lang, # Warm water generator 2
        GENW2Lang # Energy source warm water 2
      ) |>
      mutate(
        DEINR_numeric = as.numeric(gsub("\\D", "", DEINR)),
        Adresse = paste(STRNAME, DEINR, sep = " ")
      ) |>
      arrange(STRNAME, DEINR_numeric, DEINR) |>
      rename(
        `Gebäudetyp` = GKLASLang,
        `Baujahr` = GBAUJ,
        `Geschosse` = GASTW,
        `Zivilschutzraum` = GSCHUTZRLang,
        `Wärmeerzeuger Heizung 1` = GWAERZH1Lang,
        `Energiequelle Heizung 1` = GENH1Lang,
        `Wärmeerzeuger Warmwasser 1` = GWAERZW1Lang,
        `Energiequelle Warmwasser 1` = GENW1Lang,
        `Wärmeerzeuger Heizung 2` = GWAERZH2Lang,
        `Energiequelle Heizung 2` = GENH2Lang,
        `Wärmeerzeuger Warmwasser 2` = GWAERZW2Lang,
        `Energiequelle Warmwasser 2` = GENW2Lang
      )

    # Select and transform the data for apartments
    transformed_apartments <- filtered_wohnungen |>
      select(
        EGID, # Unique building ID (to join with building)
        WHGNR, # Apartment number
        EWID, # Apartment ID
        WSTAT,
        WBEZ, # location of the apartment
        WSTWKLang,
        WSTWK, # Floor
        WAZIM, # Number of rooms
        WAREA, # Living space in m2
        WMEHRGLang, # Maisonette Apartment
        WKCHELang, # is there kitchen facility
        STRNAME, # Street Name
        DEINR, # House Number
        DPLZ4, # Postal Code
        DPLZNAME # City
      ) |>
      mutate(
        DEINR_numeric = as.numeric(gsub("\\D", "", DEINR)),
        Adresse = paste(STRNAME, DEINR, sep = " "),
        # Extract numeric part from WHGNR (apartment number),
        WHGNR = stringr::str_remove(WHGNR, "Wohnung\\s"),
        whg_num = as.numeric(stringr::str_extract(WHGNR, "[:digit:]{1,}")),
        # Correct aWN values between 9800-9999 by subtracting 10,000
        aWN_korrigiert = ifelse(!is.na(whg_num) & whg_num >= 9800 & whg_num <= 9999, whg_num - 10000, whg_num)
      ) |>
      # Sort by street, house number, apartment number (whg_num), and aWn korrigiert
      arrange(
        STRNAME,
        DEINR_numeric,
        aWN_korrigiert,
        whg_num
      ) |>
      rename(
        `aWN` = WHGNR,
        `EWID` = EWID,
        `Stockwerk` = WSTWKLang,
        `Lage Wohnung` = WBEZ,
        `Zimmer` = WAZIM,
        `Wohnfläche (m2)` = WAREA,
        `Maisonette` = WMEHRGLang,
        `Küche` = WKCHELang
      )


    # Select unique addresses
    unique_addresses <- unique(building_with_address$Adresse)

    # Return the final transformed data
    return(list(
      df_building = building_with_address,
      df_apartment = transformed_apartments,
      df_unique_addresses = unique_addresses,
      df_time_stamp = time
    ))
  }
}
