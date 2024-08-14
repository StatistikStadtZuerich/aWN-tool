#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
      titlePanel("Gebäude Information"),
      
      sidebarLayout(
        sidebarPanel(
          selectInput("address", "Select Address", choices = NULL),  
          actionButton("load_data", "Daten herunterladen"),
          downloadButton("download_csv", "CSV"),
          downloadButton("download_excel", "XLSX"),
          downloadButton("download_ogd", "OGD")
        ),
        
        
        mainPanel(
          h3(textOutput("selected_address")),
          uiOutput("building_info"),
          uiOutput("entrance_info"),
          uiOutput("apartment_info")
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "awntool"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

