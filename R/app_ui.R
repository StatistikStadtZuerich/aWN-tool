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
      titlePanel("Gebäude Information"),
      
      # Sidebar layout
      sidebarLayout(
        # Sidebar with inputs
        sidebarPanel(
          mod_input_ui("input_module"),  # Address input module
          actionButton("load_data", "Abfrage")  # Button Abfrage
        ),
        
        # Main panel for outputs
        mainPanel(
          h3("Adresse eingeben"),
          p("Mit dieser Applikation können Sie Abfragen zu den amtlichen Wohnungsnummern in der Stadt Zürich machen. Geben Sie in den linken Eingabefenster die für die Abfrage gewünschte Adresse ein."),
          hr(),
          uiOutput("address_input_info")  # Placeholder for dynamic content
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
    ),
    # Example for adding ShinyJS (if needed)
    shinyjs::useShinyjs(debug = TRUE)
  )
}

