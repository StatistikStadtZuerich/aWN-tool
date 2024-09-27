#' Building Infos in BsLib two row Card
#'
#' @description Function to make a BsLib Card with Building Infos
#'
#' @param dataset Data Frame with Building Infos
#' @param height Height of the Card Container
#' @param card_min_height Minimum Height of the two Cards
#' @param card_width Width of the two Cards
#'
#' @return BsLib Card Object
#'
#' @noRd
get_card <- function(dataset, height, card_min_height, card_width) {
  tagList(
    h2(paste(dataset$Address, "(EGID", dataset$EGID, ")")),
    
    # Wrap the cards in a two-column layout
    layout_column_wrap(
      width = 1/2,  # Two columns (50% width each)
      
      # Card for "Allgemeine Informationen"
      bslib::card(
        height = "auto",
        full_screen = TRUE,
        bslib::card_header(h3("Allgemeine Informationen")),
        card_body(
          min_height = card_min_height,
          p(paste("Gebäudetyp:", dataset$GKLASLang)),
          p(paste("Baujahr:", dataset$GBAUJ)),
          p(paste("Oberirdische Geschosse:", dataset$GASTW)),
          p(paste("Unterirdische Geschosse:", dataset$GAZZI)),
          p(paste("Zivilschutzraum:", dataset$GSCHUTZRLang))
        )
      ),
      
      # Card for "Heizung & Wasser"
      bslib::card(
        height = "auto",
        full_screen = TRUE,
        bslib::card_header(h3("Heizung & Wasser")),
        card_body(
          min_height = card_min_height,
          p(paste("Wärmeerzeuger Heizung 1:", dataset$GWAERZH1Lang)),
          p(paste("Energiequelle Heizung 1:", dataset$GENH1Lang)),
          if (!is.na(dataset$GWAERZH2Lang) && dataset$GWAERZH2Lang != "") {
            p(paste("Wärmeerzeuger Heizung 2:", dataset$GWAERZH2Lang))
          },
          if (!is.na(dataset$GENH2Lang) && dataset$GENH2Lang != "") {
            p(paste("Energiequelle Heizung 2:", dataset$GENH2Lang))
          },
          p(paste("Wärmeerzeuger Warmwasser 1:", dataset$GWAERZW1Lang)),
          p(paste("Energiequelle Warmwasser 1:", dataset$GENW1Lang)),
          if (!is.na(dataset$GWAERZW2Lang) && dataset$GWAERZW2Lang != "") {
            p(paste("Wärmeerzeuger Warmwasser 2:", dataset$GWAERZW2Lang))
          },
          if (!is.na(dataset$GENW2Lang) && dataset$GENW2Lang != "") {
            p(paste("Energiequelle Warmwasser 2:", dataset$GENW2Lang))
          }
        )
      )
    )
  )
}

