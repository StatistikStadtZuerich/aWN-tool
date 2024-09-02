#' get_data
#'
#' @description Function to read the three open government datasets on which the app is based
#'
#' @details The sources of the datasets are https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/resource/0dc7e4f2-09dd-4054-a14f-9ee8e6d5b2bb,https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/resource/22094869-a3f4-44a1-a49d-a9d7dc80253a, https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/resource/69aeb436-4718-4b56-a7b5-452f37a97147 
#' 
#' @return a named list of tibbles with zones, series, and addresses
#' @noRd
#' 
#' 
# library(data.table)#package were not loaded, need to update these two into the script awn-tool package.R
# library(furrr)
get_data <- function() {
  
  # Apllying tryCatch
  tryCatch(
    expr = {
      
      # By default data is empty
      data <- NULL
      
      # Specify URLS
      URLs <- c(
        "https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/download/gwr_stzh_gebaeude.csv",
        "https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/download/gwr_stzh_gebaeudeeingaenge.csv",
        "https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/download/gwr_stzh_wohnungen.csv"
      )
      
      # Parallelisation
      data <- furrr::future_map(URLs, data_download)
      
    }, # Closing expr block
    error = function(e) {
      message("Error in Data Load: ", e)
      return(NULL)
    },
    warning = function(w) {
      message("Warning in Data Load: ", w)
    }
  ) # Closing tryCatch block
  
  # Check if any data download failed
  if (any(sapply(data, is.null))) {
    stop("One or more datasets failed to download.")
  }
  
  if (!is.null(data)) {
    ### Data Transformation
    
    # Assuming the structure of data corresponds to the downloaded datasets
    gebaeude <- data[[1]]  # First dataset
    eingang <- data[[2]]   # Second dataset
    wohnung <- data[[3]]   # Third dataset
    
    # Filter based on yellow-highlighted variables 
    filtered_gebaeude <- gebaeude %>%
      filter(GSTATLang == "Bestehend",
             GDEKT == "ZH",
             GGDENR == 261,
             GGDENAME == "Zürich")  
    
    # Select and transform the data needed for building infroamtion
    building_with_address <- filtered_gebaeude %>%
      left_join(eingang, by = "EGID") %>%  # Joining by EGID to get address data
      select(
        EGID,                # Unique building ID
        STRNAME,             # Street Name
        DEINR,               # House Number
        DPLZ4,               # Postal Code
        DPLZNAME,            # City
        GBAUJ,               # Building year
        GKLASLang,           # Building class
        GASTW,               # Number of floors
        GAZZI,               # Underground floors
        GSCHUTZRLang,        # Civil protection room
        GWAERZH1Lang,        # Heating system 1
        GENH1Lang,           # Energy source 1
        GWAERZW1Lang,        # Warm water generator 1
        GENW1Lang            # Energy source warm water 1
      ) %>%
      mutate(DEINR_numeric = as.numeric(gsub("\\D", "", DEINR)),
             Address = paste(STRNAME, DEINR,  sep = " ")  # Create a full address
      ) %>% 
      unique() %>%
      arrange(STRNAME, DEINR_numeric, DEINR)
    
    # Select and transform the data for apartments
    transformed_apartments <- wohnung %>%
      select(
        EGID,                # Unique building ID (to join with building)
        WHGNR,               # Apartment number
        EWID,                # Apartment ID
        WBEZ,                # location of the apartement
        WSTWKLang,           # Floor
        WAZIM,               # Number of rooms
        WAREA,               # Living space in m2
        WKCHELang,           # is there kitchen facility
        STRNAME,             # Street Name
        DEINR,               # House Number
        DPLZ4,               # Postal Code
        DPLZNAME             # City
      ) %>%
      mutate(DEINR_numeric = as.numeric(gsub("\\D", "", DEINR)),
             Address = paste(STRNAME, DEINR,  sep = " ")  # Create a full address
      ) %>%
      unique() %>%
      arrange(STRNAME, DEINR_numeric, DEINR)
    
    # Return the final transformed data
    return(list(
      building_info = building_with_address,
      apartment_info = transformed_apartments
    ))
  }
  
} # Closing get_data function

data <- get_data()  


