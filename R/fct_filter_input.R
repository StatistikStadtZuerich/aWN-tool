#' Filter Input
#'
#' @description function to filter the buildings and appartments according to the inputs
#'
#' @param dataset data frame with all candidates (package data)
#' @param input_values list of values for filtering
#'
#' @return dataframe with filtered data
#'
#' @noRd
filter_input <- function(dataset, input_values) {
  dataset |> 
    filter(.data[["Address"]] == input_values)
}

# filter_input(df_main[["df_apartment"]], "Langackerstrasse 14")
