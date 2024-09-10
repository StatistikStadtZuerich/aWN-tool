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
      
      tags$div(
        class = "queryDiv",
        h1("Wählen Sie eine Adresse"),
        p("Mit dieser Applikation können Sie Abfragen zu den amtlichen Wohnungsnummern in der Stadt Zürich machen."),
        hr()
      ),
      
      
      # Sidebar layout
      sidebarLayout(
        # Sidebar with inputs
        sidebarPanel(
          mod_input_ui("input_module")  # Address input module
        ),
        
        # Main panel for outputs
        mainPanel(
          
          # tbd: call mod_result functions !!!!!
          #mod_building_ui(id "asdf")
          
          # TEMPORARY OUTPUTS BEFORE MODULARIZATION
          uiOutput("building_info"),
          
          uiOutput("apartment_info"),
          tableOutput("apartment_table")
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
  
  