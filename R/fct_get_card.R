#' Building Infos in BsLib two row Card
#'
#' @description Function to make a BsLib Card with Building Infos
#'
#' @param dataset Data Frame with Building Infos
#' @param height Height of the Card Container
#' @param card_min_height Minimum Height of the two Cards
#' @param card_width Width of the two Cards
#' @param title_1 Title of left Card
#' @param title_2 Title of right Card
#'
#' @return BsLib Card Object
#'
#' @noRd
get_building_card <- function(dataset, 
                              height, 
                              card_min_height, 
                              card_width,
                              title_1 = "Allgemeine Informationen",
                              title_2 = "Heizung & Wasser") {
  tagList(
    h2(paste0(dataset$Address, " (EGID", dataset$EGID, ")")),
    
    # Wrap the cards in a two-column layout
    layout_column_wrap(
      width = 1/2,
      
      # Card for "Allgemeine Informationen"
      bslib::card(
        height = "auto",
        bslib::card_header(h2(title_1)),
        card_body(
          min_height = card_min_height,
          p(HTML(paste("Gebäudetyp:", "<span class='bold-vars'>", dataset$GKLASLang, "</span>"))),
          p(HTML(paste("Baujahr:", "<span class='bold-vars'>", dataset$GBAUJ, "</span>"))),
          p(HTML(paste("Oberirdische Geschosse:", "<span class='bold-vars'>", dataset$GASTW, "</span>"))),
          p(HTML(paste("Unterirdische Geschosse:", "<span class='bold-vars'>", dataset$GAZZI, "</span>"))),
          p(HTML(paste("Zivilschutzraum:", "<span class='bold-vars'>", dataset$GSCHUTZRLang, "</span>")))
        )
      ),
      
      # Card for "Heizung & Wasser"
      bslib::card(
        height = "auto",
        bslib::card_header(h2(title_2)),
        card_body(
          min_height = card_min_height,
          p(HTML(paste("Wärmeerzeuger Heizung 1:", "<span class='bold-vars'>", dataset$GWAERZH1Lang, "</span>"))),
          p(HTML(paste("Energiequelle Heizung 1:", "<span class='bold-vars'>", dataset$GENH1Lang, "</span>"))),
          if (!is.na(dataset$GWAERZH2Lang) && dataset$GWAERZH2Lang != "") {
            p(HTML(paste("Wärmeerzeuger Heizung 2:", "<span class='bold-vars'>", dataset$GWAERZH2Lang, "</span>")))
          },
          if (!is.na(dataset$GENH2Lang) && dataset$GENH2Lang != "") {
            p(HTML(paste("Energiequelle Heizung 2:", "<span class='bold-vars'>", dataset$GENH2Lang, "</span>")))
          },
          p(HTML(paste("Wärmeerzeuger Warmwasser 1:", "<span class='bold-vars'>", dataset$GWAERZW1Lang, "</span>"))),
          p(HTML(paste("Energiequelle Warmwasser 1:", "<span class='bold-vars'>", dataset$GENW1Lang, "</span>"))),
          if (!is.na(dataset$GWAERZW2Lang) && dataset$GWAERZW2Lang != "") {
            p(HTML(paste("Wärmeerzeuger Warmwasser 2:", "<span class='bold-vars'>", dataset$GWAERZW2Lang, "</span>")))
          },
          if (!is.na(dataset$GENW2Lang) && dataset$GENW2Lang != "") {
            p(HTML(paste("Energiequelle Warmwasser 2:", "<span class='bold-vars'>", dataset$GENW2Lang, "</span>")))
          }
        )
      )
    )
  )
}

#' Building Infos in BsLib two row Card
#'
#' @description Function to make a BsLib Card with Building Infos
#'
#' @param dataset Data Frame with Building Infos
#' @param title Title of the Info
#' @param text Text of the Info
#'
#' @return BsLib Card Object
#'
#' @noRd
get_entrance_card <- function(dataset,
                              title = "Info",
                              text = "Dieses Gebäude hat mehrere Eingänge mit unterschiedlichen Adressen. Wenn Sie Wohnungsinformationen zu einem der untenstehenden Eingängen suchen, geben Sie diese Adresse ins Suchfeld links ein.") {
  ssz_icons <- icons::icon_set("inst/app/www/icons/")
  tagList(
    tags$div(
      class = "info_na_div",
      tags$div(
        class = "info_na_icon",
        img(ssz_icons$`warning`)
      ),
      tags$div(
        class = "info_na_text",
        h6(title),
        p(text),
          reactable(
            dataset  %>%
              select(Address) %>%
              rename(`Adresse` = Address),
            columns = list(
              `Adresse` = colDef(name = "Weitere Eingänge")
            ),
            highlight = FALSE,
            bordered = FALSE,
            striped = FALSE,
            resizable = FALSE
        )
      )
    )
  )
}


#' Appartment Infos in BsLib Card
#'
#' @description Function to make a BsLib Card with Apparment Infos
#'
#' @param dataset Data Frame with Building Infos
#' @param title Title of the Card
#'
#' @return BsLib Card Object
#'
#' @noRd
get_apartment_card <- function(dataset = sorted_apartments, 
                               title = "Informationen zu den Wohnungen") {
  tagList(
    bslib::card(
      bslib::card_header(h2(title)),
      reactable(
        dataset %>%
          select(WHGNR, EWID, WSTWKLang, WBEZ, WAZIM, WAREA, WKCHELang) %>%
          rename(
            `aWN` = WHGNR,
            `EWID` = EWID,
            `Stockwerk` = WSTWKLang,
            `Lage Wohnung` = WBEZ,
            `Zimmer` = WAZIM,
            `Wohnfläche (m2)` = WAREA,
            `Küche` = WKCHELang
          ),
        columns = list(
          `aWN` = colDef(minWidth  = 50), 
          `EWID` = colDef(minWidth  = 50),
          `Stockwerk` = colDef(minWidth  = 100), 
          `Lage Wohnung` = colDef(minWidth  = 80), 
          `Zimmer` = colDef(minWidth  = 60),  
          `Wohnfläche (m2)` = colDef(), 
          `Küche` = colDef()
        ),
        fullWidth = TRUE
      )
    ),
    tags$div(
      class = "infoDiv",
      h5("Erklärungen"),
      p("aWN = amtliche Wohnungsnummer"),
      p("EWID = Eidgenössischer Wohnungsidentifikator")
    )
  )
}

