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

      # Infos output
      uiOutput(ns("info")),

      # Time stamp Output
      uiOutput(ns("timestamp"))
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

    # Output for Building Infos
    output$building_info <- renderUI({
      get_building_card(
        dataset = building_data,
        height = "auto",
        card_min_height = "auto",
        card_width = 1 / 2
      )
    })

    # Output for Entrance Infos: Check for multiple entrances (i.e., multiple EDIDs for the same EGID)
    selected_egid <- building_data$EGID[1]
    selected_address <- building_data$Adresse[1]

    # Filter building data to get all entries with the same EGID
    building_multiple_entries <- df_main[["df_building"]] |>
      filter(EGID == selected_egid)

    # Exclude the selected address
    entrances_to_show <- building_multiple_entries |>
      filter(Adresse != selected_address)

    # Check if there are multiple entrances (distinct EDIDs)
    if (n_distinct(entrances_to_show$EDID) >= 1) {
      output$entrance_info <- renderUI({
        get_entrance_card(
          dataset = entrances_to_show
        )
      })

      # Render additional Infos
      output$info <- renderUI({
        tags$div(
          class = "infoDiv",
          h5("Erläuterungen"),
          p("Anzahl Zimmer = halbe Zimmer werden abgerundet"),
          p("aWN = amtliche Wohnungsnummer"),
          p("EGID = Eidgenössischer Gebäudeidentifikator"),
          p("EWID = Eidgenössischer Wohnungsidentifikator"),
          p("Geschosse = umfasst unter- und oberirdische Geschosse")
        )
      })

      # Render the Timestamp
      output$timestamp <- renderUI({
        p(paste("Stand der letzten Datenaktualisierung:", df_main[["df_time_stamp"]]))
      })
    } else {
      output$entrance_info <- renderUI({
        NULL
      })
    }

    # Apartment Infos
    if (nrow(apartment_data) > 0) {
      # Sort the apartments by aWN_korrigiert (if necessary)
      sorted_apartments <- apartment_data

      # Check if there is aparments in building progress
      aparments_progress <- sorted_apartments |>
        filter(WSTAT == 3003)

      # Conditional Ouput for aparments in progress
      if (nrow(aparments_progress) > 0) {
        output$apartment_infos <- renderUI({
          get_apartment_card(
            dataset = sorted_apartments,
            progress = 1
          )
        })
      } else {
        output$apartment_infos <- renderUI({
          get_apartment_card(
            dataset = sorted_apartments,
            progress = 0
          )
        })
      }

      # Render additional Infos
      output$info <- renderUI({
        tags$div(
          class = "infoDiv",
          h5("Erläuterungen"),
          p("Anzahl Zimmer = halbe Zimmer werden abgerundet"),
          p("aWN = amtliche Wohnungsnummer"),
          p("EGID = Eidgenössischer Gebäudeidentifikator"),
          p("EWID = Eidgenössischer Wohnungsidentifikator"),
          p("Geschosse = umfasst unter- und oberirdische Geschosse")
        )
      })

      # Render the Timestamp
      output$timestamp <- renderUI({
        p(paste("Stand der letzten Datenaktualisierung:", df_main[["df_time_stamp"]]))
      })
    } else {
      # Render a blank table or a message when no apartments are found
      output$apartment_infos <- renderUI({
        get_na_info()
      })

      # Render additional Infos
      output$info <- renderUI({
        tags$div(
          class = "infoDiv",
          h5("Erläuterungen"),
          p("EGID = Eidgenössischer Gebäudeidentifikator"),
          p("Geschosse = umfasst unter- und oberirdische Geschosse"),
        )
      })

      # Render the Timestamp
      output$timestamp <- renderUI({
        p(paste("Stand der letzten Datenaktualisierung:", df_main[["df_time_stamp"]]))
      })
    }
  })
}
