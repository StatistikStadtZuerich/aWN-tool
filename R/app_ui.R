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

      # Action Button and Download grouped inside .button-div
      tags$div(class = "button-div",
        # Action Button
        sszActionButton(
          "ActionButtonId",
          "Abfrage starten"
        ),

        # Download UI: hidden on load, shown by shinyjs::show() after valid query
        shinyjs::hidden(
          tags$div(id = "download_wrapper",
            mod_download_ui("download_1")
          )
        )
      ),

      # Results: hidden on load, shown by shinyjs::show() after valid query
      shinyjs::hidden(
        tags$div(id = "results_wrapper",
          mod_results_ui("results_1")
        )
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
#' @importFrom golem add_resource_path activate_js bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "awntool"
    ),
    # ShinyJS for conditional UI
    shinyjs::useShinyjs(debug = TRUE),
    
    # Trigger action button on Enter key in autocomplete input
    js_trigger_on_enter("input_module-address", "ActionButtonId"),
  )
}
