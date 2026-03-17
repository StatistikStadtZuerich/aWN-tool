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
    #includeCSS("inst/app/www/aWNTheme.css"),

    # Page layout
    ssz_page(

      # Input Module
      mod_input_ui("input_module"),

      # Action Button
      sszActionButton(
        "ActionButtonId",
        "Abfrage starten"
      ),

      # Results and Download (shown only when server confirms valid results)
      conditionalPanel(
        condition = "output.show_results == true",
        mod_results_ui("results_1"),
        mod_download_ui("download_1")
      ),
      uiOutput("warning")
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
    ),
    # ShinyJS for conditional UI
    shinyjs::useShinyjs(debug = TRUE),
    
    # Trigger action button on Enter key in autocomplete input
    js_trigger_on_enter("input_module-address", "ActionButtonId"),
    
    # Explicitly include aWNTheme.css
    tags$link(rel = "stylesheet", type = "text/css", href = "www/awntheme.css")
  )
}
