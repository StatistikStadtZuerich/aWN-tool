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
    ssz_page(

      # Input Module
      mod_input_ui("input_module"),

      # Action Button
      sszActionButton(
        "ActionButtonId",
        "Abfrage starten"
      ),

      # Results (shown only when server confirms valid results)
      conditionalPanel(
        condition = "output.show_results == true",
        mod_results_ui("results_1")
      ),
      uiOutput("warning"),

      # Download Module (shown after results; on mobile appears at the end)
      conditionalPanel(
        condition = "output.show_results == true",
        mod_download_ui("download_1")
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
    # ShinyJS for conditional UI
    shinyjs::useShinyjs(),
    # Trigger action button on Enter key in autocomplete input
    tags$script(HTML("
      $(document).on('keydown', '#input_module-address', function(e) {
        if (e.key === 'Enter') {
          e.preventDefault();
          $('#ActionButtonId').click();
        }
      });
    "))
  )
}
