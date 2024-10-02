#' Info Div when for Buildings with no Appartments
#'
#' @description Function to create a Warning div
#'
#' @param title Title that should appear in the block
#' @param text Text that should appear in the block
#'
#' @return Div
#'
#' @noRd
get_na_info <- function(title = "Info",
                        text = "In diesem Gebäude gibt es keine Wohnungen.") {
  ssz_icons <- icons::icon_set("inst/app/www/icons/")
  tags$div(
    class = "info_na_div",
    tags$div(
      class = "info_na_icon",
      img(ssz_icons$`warning`)
    ),
    tags$div(
      class = "info_na_text",
      h6(title),
      p(text)
    )
  )
}
