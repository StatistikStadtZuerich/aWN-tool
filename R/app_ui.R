#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # External resources (e.g., CSS, JS)
    golem_add_external_resources(),
    
    # Page layout
    fluidPage(
      
      # TEMPORARY: until golem_add_external_resources() works
      includeCSS("inst/app/www/sszThemeShiny.css"),
      includeCSS("inst/app/www/aWNTheme.css"),
      tags$div(
        class = "queryDiv",
        h1("Wählen Sie eine Adresse"),
        p("Mit dieser Applikation können Sie Abfragen zu Daten im Gebäude- und Wohnungsregister der Stadt Zürich durchführen. Unter anderem finden Sie Angaben zu den amtlichen Wohnungsnummern, Energieträgern und weiteren Informationen."),
        hr()
      ),
      
      # Sidebar: Input widgets are placed here
      sidebarLayout(
        sidebarPanel(
          
          # Input Module
          mod_input_ui("input_module"),
          
          # Action Button
          sszActionButton(
            "ActionButtonId",
            "Abfrage starten"  # Initial label
          ),
          
          # Conditionally show download UI after the action button is clicked and address is selected
          uiOutput("download_ui")  
        ),
        
        # Main Panel: Outputs are placed here
        mainPanel(
          mod_results_ui("results_1"),
          htmlOutput("timestamp")
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
      app_title = "aWNtool"
    ),
    # Example for adding ShinyJS (if needed)
    shinyjs::useShinyjs(debug = TRUE)
  )
}
