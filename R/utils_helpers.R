#' Build Stadtplan URL for Zurich map
#'
#' @param data A data frame with columns lokalisationsname, hausnummer, gebaeudeeingangnummer (single row)
#' @return A character string with the constructed URL
#' @noRd
build_stadtplan_url <- function(data) {
  #stopifnot(nrow(data) == 1)
  
  # Extract values safely
  lok <- data$STRNAME
  hnr <- data$DEINR
  eingang <- data$gebaeudeeingangnummer
  
  # Construct the full URL
  paste0(
    "https://www.maps.stadt-zuerich.ch/zueriplan3/Stadtplan.aspx?adresse=",
    lok, "%20", hnr,
    "&selectedObject=adr", eingang,
    "&toggleScreen=1"
  )
}

#' Load SSZ icons
#'
#' Loads the SSZ icon set from the inst/app/www/icons/ directory.
#'
#' @return An icon set object from the \code{icons} package.
#' @noRd
ssz_icons <- function() {
  icons::icon_set(here::here("inst/app/www/icons/"))
}

#' Trigger a button click on Enter keypress in an input
#'
#' Generates a \code{<script>} tag that listens for the Enter key
#' on the given input and programmatically clicks the target button.
#'
#' @param inputId The DOM id of the input element (e.g. \code{"input_module-address"}).
#' @param buttonId The DOM id of the button to trigger (e.g. \code{"ActionButtonId"}).
#'
#' @return A \code{tags$script} element to include in the UI.
#' @noRd
js_trigger_on_enter <- function(inputId, buttonId) {
  tags$script(HTML(sprintf("
    $(document).on('keydown', '#%s', function(e) {
      if (e.key === 'Enter') {
        e.preventDefault();
        $('#%s').click();
      }
    });
  ", inputId, buttonId)))
}
