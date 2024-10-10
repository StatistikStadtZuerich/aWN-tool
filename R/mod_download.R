#' download UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_download_ui <- function(id) {
  ns <- NS(id)

  # Icons
  ssz_icons <- icons::icon_set("inst/app/www/icons/")

  # Download Buttons
  tagList(
    tags$div(
      id = ns("downloadWrapperId"),
      class = "downloadWrapperDiv",
      sszDownloadButton(
        outputId = ns("excel_download"),
        label = "xlsx",
        image = img(ssz_icons$download)
      ),
      sszOgdDownload(
        outputId = ns("ogd_download"),
        label = "OGD",
        href = "https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell"
      )
    )
  )
}

#' download Server Functions
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param building_data The filtered building data to be downloaded.
#' @param apartment_data The filtered apartment data to be downloaded.
#' @noRd
mod_download_server <- function(id, building_data, apartment_data, fct_create_excel) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Prepare the data for download, filtering based on the displayed content
    data_for_download <- reactive({
      # Data with Building Infos
      building_info <- building_data() |>
        select(Adresse, EGID, Gebäudetyp, Baujahr, `Oberirdische Geschosse`, `Unterirdische Geschosse`, `Zivilschutzraum`, `Wärmeerzeuger Heizung 1`, `Energiequelle Heizung 1`, `Wärmeerzeuger Warmwasser 1`, `Energiequelle Warmwasser 1`)

      # Data with Aparment Infos
      apartment_info <- apartment_data() |>
        select(Adresse, aWN, EWID, Stockwerk, `Lage Wohnung`, Zimmer, `Wohnfläche (m2)`, Küche)

      # Number of Aparments
      number_aparments <- nrow(apartment_info)

      # Address
      address <- building_data()$Adresse[1]

      # Combine the building and apartment data
      list(
        Building_Info = building_info,
        Apartment_Info = apartment_info,
        Address = address,
        Number_Aparments = number_aparments
      )
    })

    # Excel Download
    output$excel_download <- downloadHandler(
      filename = function() {
        # Use the address from data_for_download() and replace spaces with underscores
        address <- gsub(" ", "_", data_for_download()$Address)
        paste0("Gebäude_und_Wohnungsinformationen_", address, "_", Sys.Date(), ".xlsx")
      },
      content = function(file) {
        fct_create_excel(file, data_for_download())
      }
    )
  })
}

## To be copied in the UI
# mod_download_ui("download_1")

## To be copied in the server
# mod_download_server("download_1", building_data, apartment_data)
