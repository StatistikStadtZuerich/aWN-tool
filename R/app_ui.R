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
        p("Mit dieser Applikation können Sie Abfragen zu den amtlichen Wohnungsnummern in der Stadt Zürich machen."),
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
          
          # Downloads (Appears only if both ActionButtonId > 0 and input_module_address is filled)
          mod_download_ui("download_1")
          #conditionalPanel(
          # condition = "input.ActionButtonId > 0 && input['input_module-address'] !== null && input['input_module-address'] !== ''", # Button clicked AND address filled properly
          #  h3("Daten herunterladen"),
          #  mod_download_ui("download_1") # Include the download module UI
          #)
        ),
        
        # Main Panel: Outputs are placed here
        mainPanel(
          mod_results_ui("results_1")
          #conditionalPanel(
          # condition = "input.ActionButtonId > 0 && input['input_module-address'] !== null && input['input_module-address'] !== ''",
          # mod_results_ui("results_1")
          # )
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
