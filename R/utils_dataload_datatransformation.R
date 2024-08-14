#' get_data
#'
#' @description Function to read the three open government datasets on which the app is based
#'
#' @details The sources of the datasets are https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/resource/0dc7e4f2-09dd-4054-a14f-9ee8e6d5b2bb,https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/resource/22094869-a3f4-44a1-a49d-a9d7dc80253a, https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/resource/69aeb436-4718-4b56-a7b5-452f37a97147 
#' 
#' @return a named list of tibbles with zones, series, and addresses
#' @noRd
get_data <- function() {
  
  # Applying tryCatch
  tryCatch(
    expr = { # Specifying expression
      # By default the data frame is empty
      data <- NULL
      
      ## URLS
      URLs <- c(
        "https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/download/gwr_stzh_gebaeude.csv", #gebäude
        "https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/download/gwr_stzh_gebaeudeeingaenge.csv",#eingang
        "https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/download/gwr_stzh_wohnungen.csv" #wohnung

      )
      
      ## Download
      dataDownload <- function(link) {
        data <- fread(link, encoding = "UTF-8"
        )
        
        return(data)
      }
      
      # Parallelisation
      data <- future_map(URLs, dataDownload)
    },
    error = function(e) { # Specifying error message
      message("Error in Data Load")
      return(NULL)
    },
    warning = function(w) { # Specifying warning message
      message("Warning in Data Load")
    }
  )
  
  if (!is.null(data)) {
    ### Data Transformation
    
    ## Zones
    zones <- data[[1]] %>%
      mutate(PreisreiheLang = case_when(PreisreiheSort == 41 ~ "Preis pro m\u00B2 Grundstücksfläche",
                                        PreisreiheSort == 42 ~ "Preis pro m\u00B2 Grundstücksfläche, abzgl. Versicherungswert",
                                        PreisreiheSort == 49 ~ "Stockwerkeigentum pro m\u00B2 Wohnungsfläche")) %>%
      mutate(across(everything(), \(x) replace(x, x == ".", "–")))  %>%
      mutate(across(everything(), \(x) replace(x, x == "", "–"))) %>% 
      mutate(ArtLang = case_when(
        ArtLang == "Ganze Liegenschaft" ~ "Ganze Liegenschaften",
        TRUE ~ ArtLang))
    
    ## BZO16
    zonesBZO16 <- zones %>%
      filter(BZO == "BZO16") %>%
      rename(
        Total = ALLE,
        Z = ZE,
        K = KE,
        Q = QU,
        W2 = W2,
        W3 = W23,
        W4 = W34,
        W5 = W45,
        W6 = W56
      ) %>%
      mutate(across(everything(), \(x) replace(x, x == ".", "–")))  %>%
      mutate(across(everything(), \(x) replace(x, x == "", "–")))
    
    ## BZO99
    zonesBZO99 <- zones %>%
      filter(BZO == "BZO99") %>%
      rename(
        Total = ALLE,
        Z = ZE,
        K = KE,
        Q = QU,
        ` ` = W2,
        W2 = W23,
        W3 = W34,
        W4 = W45,
        W5 = W56
      ) %>%
      mutate(across(everything(), \(x) replace(x, x == ".", "–")))  %>%
      mutate(across(everything(), \(x) replace(x, x == "", "–")))
    
    ## Series
    series <- data[[2]] %>%
      mutate(across(everything(), \(x) replace(x, x == ".", "–"))) %>%
      mutate(across(c(
        FrQmBodenGanzeLieg,
        FrQmBodenStwE,
        FrQmBodenAlleHA
      ), \(x) replace(x, x == "", "–"))
      )
    
    ## Addresses
    addresses <- data[[3]] %>%
      mutate(Zones = case_when(
        ZoneBZO16Lang == ZoneBZO99Lang ~ paste(ZoneBZO16Lang),
        TRUE ~ paste0(ZoneBZO16Lang, " (bis 2018: ", ZoneBZO99Lang, ")")
      )) %>% 
      mutate(ZoneBZO99Lang = case_when(
        ZoneBZO99Lang == "Wohnzone 2" ~ "Wohnzonen 2",
        ZoneBZO99Lang == "Wohnzone 3" ~ "Wohnzonen 3",
        ZoneBZO99Lang == "Wohnzone 4" ~ "Wohnzonen 4",
        ZoneBZO99Lang == "Wohnzone 5" ~ "Wohnzonen 5",
        TRUE ~ ZoneBZO99Lang
      ))
    
    
    ## Building Type
    types <- data[[4]] %>%
      mutate(PreisreiheLang = case_when(PreisreiheSort == 41 ~ "Preis pro m\u00B2 Grundstücksfläche",
                                        PreisreiheSort == 42 ~ "Preis pro m\u00B2 Grundstücksfläche, abzgl. Versicherungswert",
                                        PreisreiheSort == 49 ~ "Stockwerkeigentum pro m\u00B2 Wohnungsfläche")) %>%
      mutate(ArtLang = case_when(ArtSort == 31 ~ "Ganze Liegenschaften",
                                 ArtSort == 32 ~ "Nur Stockwerkeigentum",
                                 ArtSort == 39 ~ "Alle Handänderungen")) %>%
      mutate(across(everything(), \(x) replace(x, x == ".", "–")))  %>%
      mutate(across(everything(), \(x) replace(x, x == "", "–")))
    
    
    ## Series Building Type
    seriestypes <- data[[5]] %>%
      mutate(across(everything(), \(x) replace(x, x == ".", "–"))) %>%
      mutate(across(c(
        FrQmBodenGanzeLieg,
        FrQmBodenStwE,
        FrQmBodenAlleHA
      ), \(x) replace(x, x == "", "–"))
      )
    
    return(list(
      zones = zones,
      zonesBZO16 = zonesBZO16,
      zonesBZO99 = zonesBZO99,
      series = series,
      addresses = addresses,
      types = types,
      seriestypes = seriestypes
    ))
    
  }
}


data_vector <- get_data()
