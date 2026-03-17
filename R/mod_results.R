#' results UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_results_ui <- function(id) {
  ns <- NS(id)
  withSpinner(
    tagList(

      # Card with Building Infos
      uiOutput(ns("building_info")),

      # UI output for multiple entrances (only displayed when applicable)
      uiOutput(ns("entrance_info")), # Add this line to include entrance info UI

      # Reactable Output with Apartment Infos
      uiOutput(ns("apartment_infos")),

      # Time stamp Output
      uiOutput(ns("timestamp")),

      # Infos output
      uiOutput(ns("info"))

    ),
    type = 7,
    color = "#0F05A0"
  )
}

#' results Server Functions
#' @param building_data data frame to be shown in bslib card with building_info
#' @param entrance_data data frame to be shown in additional reactable, reactive
#' @param apartment_data data frame to be shown in main reactable, reactive
#'
#' @noRd
mod_results_server <- function(id, building_data, apartment_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Call Data to make it static
    building_data <- building_data()
    apartment_data <- apartment_data()

    # Entrance Infos
    selected_egid <- building_data$EGID[1]
    selected_address <- building_data$Adresse[1]

    entrances_to_show <- data_main[["df_building"]] |>
      filter(EGID == selected_egid, Adresse != selected_address)

    url_to_show <- data_main[["df_building"]] |>
      filter(EGID == selected_egid, Adresse == selected_address)
    
    stadtplan_url <- build_stadtplan_url(url_to_show)

    # Output for Building Infos
    output$building_info <- renderUI({
      get_building_card(
        dataset = building_data,
        height = "auto",
        card_min_height = "auto",
        card_width = 1 / 2,
        stadtplan_url = stadtplan_url
      )
    })

    # Check if there are multiple entrances (distinct EGIDs)
    if (nrow(entrances_to_show) > 0) {
      output$entrance_info <- renderUI({
        get_entrance_card(dataset = entrances_to_show)
      })
    } else {
      output$entrance_info <- renderUI(NULL)
    }

    # Apartment Infos
    if (nrow(apartment_data) > 0) {
      has_progress <- any(apartment_data$WSTAT == 3003)

      output$apartment_infos <- renderUI({
        get_apartment_card(
          dataset = apartment_data,
          progress = as.integer(has_progress)
        )
      })

      # Info text includes apartment-specific explanations
      info_items <- get_info_items("apartment")
    } else {
      output$apartment_infos <- renderUI({
        sszInfoBox(
          title = "Info",
          text = "In diesem Gebäude gibt es keine Wohnungen.",
          icon = ssz_icons()("info-help-filled")
        )
      })

      # Info text for buildings without apartments (fewer items)
      info_items <- get_info_items("building")
    }

    # Info & Timestamp
    output$info <- renderUI({
      sszContextBox(
        title = "Erläuterungen",
        text = info_items
      )
    })

    output$timestamp <- renderUI({
      tagList(
        br(),
        tags$p(paste("Stand der letzten Datenaktualisierung:", data_main[["df_time_stamp"]]))
      )
    })
  })
}
