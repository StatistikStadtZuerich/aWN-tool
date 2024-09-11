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
  bslib::card(
    height = height,
    full_screen = TRUE,
    bslib::card_header(h2(paste("Informationen zum Gebäude mit EGID:", dataset$EGID))),
    card_body(
      min_height = card_min_height,
      layout_column_wrap(
        width = card_width,
        tagList(
          h4("Allgemeine Informationen"),
          p(paste("Gebäudetyp:", dataset$GKLASLang)),
          p(paste("Baujahr:", dataset$GBAUJ)),
          p(paste("Oberirdische Geschosse:", dataset$GASTW)),
          p(paste("Unterirdische Geschosse:", dataset$GAZZI)),
          p(paste("Zivilschutzraum:", dataset$GSCHUTZRLang))
        ),
        tagList(
          h4("Heizung & Wasser"),
          p(paste("Wärmeerzeuger Heizung 1:", dataset$GWAERZH1Lang)),
          p(paste("Energiequelle Heizung 1:", dataset$GENH1Lang)),
          p(paste("Wärmeerzeuger Heizung 2:", dataset$GWAERZH2Lang)),
          p(paste("Energiequelle Heizung 2:", dataset$GENH2Lang)),
          p(paste("Wärmeerzeuger Warmwasser 1:", dataset$GWAERZW1Lang)),
          p(paste("Energiequelle Warmwasser 1:", dataset$GENW1Lang)),
          p(paste("Wärmeerzeuger Warmwasser 2:", dataset$GWAERZW2Lang)),
          p(paste("Energiequelle Warmwasser 2:", dataset$GENW2Lang))
          
        )
      )
    )
  )
}


