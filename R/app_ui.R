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
          mod_input_ui("input_module")  # Address input module (with Abfrage button inside the module)
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
