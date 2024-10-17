#' Info Div for Buildings with no Appartments
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

#' Info Div for invalid addresses
#'
#' @description Function to create a Warning div
#'
#' @param dataset Dataset with address from input that is invalid
#' @param title Title that should appear in the block
#'
#' @return Div
#'
#' @noRd
get_warning <- function(dataset,
                        title = "Ungültige Adresseingabe") {
  ssz_icons <- icons::icon_set("inst/app/www/icons/")
  invalid_address <- dataset
  tags$div(
    class = "info_na_div",
    tags$div(
      class = "info_na_icon",
      img(ssz_icons$`warning`)
    ),
    tags$div(
      class = "info_na_text",
      h6(title),
      p(HTML(paste0("Die Adresse ", "<span class='bold-vars'>«", invalid_address, "»</span>", " existiert nicht.")))
    )
  )
}
