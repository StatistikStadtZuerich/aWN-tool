#' ssz_download_excel
#'
#' @param file file path where excel is to be saved
#' @param data_for_download list with data
#'
#' @noRd
#'
#'
ssz_download_excel <- function(file, data_for_download) {
  building_info <- data_for_download$Building_Info
  apartment_info <- data_for_download$Apartment_Info
  address <- data_for_download$Address
  numb_aparments <- data_for_download$Number_Aparments

  # Data Paths
  path_title_page <- "inst/app/www/Titelblatt.xlsx"
  path_logo <- "inst/app/www/logo_stzh_stat_sw_pos_1.png"

  # Styling
  sty <- createStyle(fgFill = "#ffffff")
  styConcept <- createStyle(
    textDecoration = c("bold"),
    valign = "top",
    wrapText = FALSE
  )
  styDefinition <- createStyle(
    valign = "top",
    wrapText = TRUE
  )
  styTitle <- createStyle(fontName = "Arial Black")

  # Create Workbook
  wb <- createWorkbook()

  # Read Data
  if (numb_aparments == 0) {
    # Read Titelblatt
    data <- read_excel(path_title_page, sheet = 1)

    # Data Sheet 1
    data <- data |>
      mutate(
        Date = case_when(
          is.na(Date) ~ NA,
          TRUE ~ df_main[["df_time_stamp"]]
        ),
        Titel = case_when(
          is.na(Titel) ~ NA,
          Info == "T_1" ~ paste("Gebäudeinformationen für Ihre Auswahl:", address)
        )
      )

    # Title for Data Sheet 1
    T_1 <- list(c(
      "T_1", "Gebäudeinformationen für Ihre Auswahl:",
      address, " ", " ", "Quelle: Statistik Stadt Zürich, Präsidialdepartement"
    )) |>
      as.data.frame()

    # Read sheet for Definitions
    definitions <- read_excel(path_title_page, sheet = 3)

    # Add Sheets
    addWorksheet(wb, sheetName = "Inhalt", gridLines = FALSE)
    addWorksheet(wb, sheetName = "Erläuterungen", gridLines = FALSE)
    addWorksheet(wb, sheetName = "T_1", gridLines = TRUE)

    # Write Table Sheet 1
    writeData(wb,
      sheet = 1, x = data,
      colNames = FALSE, rowNames = FALSE,
      startCol = 2,
      startRow = 7,
      withFilter = FALSE
    )

    # Write Definitions
    writeData(wb,
      sheet = 2, x = definitions,
      colNames = FALSE, rowNames = FALSE,
      startCol = 1,
      startRow = 1,
      withFilter = FALSE
    )

    # Write Table Sheet 3
    writeData(wb,
      sheet = 3, x = T_1,
      colNames = FALSE, rowNames = FALSE,
      startCol = 1,
      startRow = 1,
      withFilter = FALSE
    )
    writeData(wb,
      sheet = 3, x = building_info,
      colNames = TRUE, rowNames = FALSE,
      startCol = 1,
      startRow = 9,
      withFilter = FALSE
    )

    # Insert Logo on Sheet 1
    insertImage(wb, path_logo, sheet = 1, startRow = 2, startCol = 2, width = 1.75, height = 0.35)

    # Add Styling
    addStyle(wb, 1, style = sty, row = 1:19, cols = 1:6, gridExpand = TRUE)
    addStyle(wb, 1, style = styTitle, row = 14, cols = 2, gridExpand = TRUE)
    addStyle(wb, 2, style = styConcept, row = 1:5, cols = 1, gridExpand = TRUE)
    addStyle(wb, 3, style = styConcept, row = 9, cols = 1:50, gridExpand = TRUE)
    modifyBaseFont(wb, fontSize = 8, fontName = "Arial")

    # Set Column Width for Sheet 2
    column_names <- LETTERS[1:12]
    widths <- c(30, 12, 30, 10, 30, 30, 30, 30, 30, 30, 30, 30)
    purrr::map2(
      column_names, widths,
      \(x, y) setColWidths(wb, sheet = 3, cols = x, widths = y)
    )

    # Set Column Width for overview sheet
    setColWidths(wb, sheet = 1, cols = "A", widths = 1)
    setColWidths(wb, sheet = 1, cols = "B", widths = 4)
    setColWidths(wb, sheet = 1, cols = "D", widths = 40)
    setColWidths(wb, sheet = 1, cols = "E", widths = 18)
    
    # Set Column Width for definition sheet
    setColWidths(wb, sheet = 2, cols = "A", widths = 18)
    setColWidths(wb, sheet = 2, cols = "B", widths = 40)

    # Save Excel
    saveWorkbook(wb, file, overwrite = TRUE) ## save to working directory
  } else if (numb_aparments >= 1) {
    # Read Titelblatt
    data <- read_excel(path_title_page, sheet = 2)

    # Data Sheet 1
    data <- data |>
      mutate(
        Date = case_when(
          is.na(Date) ~ NA,
          TRUE ~ df_main[["df_time_stamp"]]
        ),
        Titel = case_when(
          is.na(Titel) ~ NA,
          Info == "T_1" ~ paste("Gebäudeinformationen für Ihre Auswahl:", address),
          Info == "T_2" ~ paste("Wohnungsinformationen für Ihre Auswahl:", address)
        )
      )

    # Title for Data Sheet 1
    T_1 <- list(c(
      "T_1", "Gebäudeinformationen für Ihre Auswahl:",
      address, " ", " ", "Quelle: Statistik Stadt Zürich, Präsidialdepartement"
    )) |>
      as.data.frame()

    # Title for Data Sheet 2
    T_2 <- list(c(
      "T_2", "Wohnungsinformationen für Ihre Auswahl:",
      address, " ", " ", "Quelle: Statistik Stadt Zürich, Präsidialdepartement"
    )) |>
      as.data.frame()

    # Read sheet for Definitions
    definitions <- read_excel(path_title_page, sheet = 3)

    # Add Sheets
    addWorksheet(wb, sheetName = "Inhalt", gridLines = FALSE)
    addWorksheet(wb, sheetName = "Erläuterungen", gridLines = TRUE)
    addWorksheet(wb, sheetName = "T_1", gridLines = TRUE)
    addWorksheet(wb, sheetName = "T_2", gridLines = TRUE)

    # Write Table Sheet 1
    writeData(wb,
      sheet = 1, x = data,
      colNames = FALSE, rowNames = FALSE,
      startCol = 2,
      startRow = 7,
      withFilter = FALSE
    )

    # Write Definitions
    writeData(wb,
      sheet = 2, x = definitions,
      colNames = FALSE, rowNames = FALSE,
      startCol = 1,
      startRow = 1,
      withFilter = FALSE
    )

    # Write Table Sheet 3
    writeData(wb,
      sheet = 3, x = T_1,
      colNames = FALSE, rowNames = FALSE,
      startCol = 1,
      startRow = 1,
      withFilter = FALSE
    )
    writeData(wb,
      sheet = 3, x = building_info,
      colNames = TRUE, rowNames = FALSE,
      startCol = 1,
      startRow = 9,
      withFilter = FALSE
    )

    # Write Table Sheet 4
    writeData(wb,
      sheet = 4, x = T_2,
      colNames = FALSE, rowNames = FALSE,
      startCol = 1,
      startRow = 1,
      withFilter = FALSE
    )
    writeData(wb,
      sheet = 4, x = apartment_info,
      colNames = TRUE, rowNames = FALSE,
      startCol = 1,
      startRow = 9,
      withFilter = FALSE
    )

    # Insert Logo on Sheet 1
    insertImage(wb, path_logo, sheet = 1, startRow = 2, startCol = 2, width = 1.75, height = 0.35)

    # Add Styling
    addStyle(wb, 1, style = sty, row = 1:19, cols = 1:6, gridExpand = TRUE)
    addStyle(wb, 1, style = styTitle, row = 14, cols = 2, gridExpand = TRUE)
    addStyle(wb, 2, style = styConcept, row = 1:5, cols = 1, gridExpand = TRUE)
    addStyle(wb, 3, style = styConcept, row = 9, cols = 1:50, gridExpand = TRUE)
    addStyle(wb, 4, style = styConcept, row = 9, cols = 1:50, gridExpand = TRUE)
    modifyBaseFont(wb, fontSize = 8, fontName = "Arial")

    # Set Column Width for Sheet 2
    column_names_1 <- LETTERS[1:12]
    widths_1 <- c(25, 12, 30, 10, 30, 30, 30, 30, 30, 30, 30, 30)
    purrr::map2(
      column_names_1, widths_1,
      \(x, y) setColWidths(wb, sheet = 3, cols = x, widths = y)
    )

    # Set Column Width for Sheet 3 (only for 8 columns)
    column_names_2 <- LETTERS[1:9] # Adjusted to match the number of widths
    widths_2 <- c(30, 12, 12, 20, 20, 20, 20, 20, 20)
    purrr::map2(
      column_names_2, widths_2,
      \(x, y) setColWidths(wb, sheet = 4, cols = x, widths = y)
    )

    # Set Column Width for overview sheet
    setColWidths(wb, sheet = 1, cols = "A", widths = 1)
    setColWidths(wb, sheet = 1, cols = "B", widths = 4)
    setColWidths(wb, sheet = 1, cols = "D", widths = 40)
    setColWidths(wb, sheet = 1, cols = "E", widths = 18)
    
    # Set Column Width for definition sheet
    setColWidths(wb, sheet = 2, cols = "A", widths = 18)
    setColWidths(wb, sheet = 2, cols = "B", widths = 40)

    # Save Excel
    saveWorkbook(wb, file, overwrite = TRUE) ## save to working directory
  }
}
