#' data_download
#' @description Function to download the data from Open Data Zürich
#'
#' @param link URL to the csv
#'
#' @return tibble, downloaded from link plus "Wahljahr" column added
#' @noRd
data_download <- function(link) {
  data.table::fread(link, encoding = "UTF-8")
}
