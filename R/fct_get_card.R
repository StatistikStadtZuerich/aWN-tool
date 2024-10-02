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
    h2(paste0(dataset$Adresse, " (EGID ", dataset$EGID, ")")),

    # Wrap the cards in a two-column layout
    layout_column_wrap(
      width = 1 / 2,

      # Card for "Allgemeine Informationen"
      bslib::card(
        height = "auto",
        bslib::card_header(h2(title_1)),
        card_body(
          min_height = card_min_height,
          p(HTML(paste("Gebäudetyp:", "<span class='bold-vars'>", dataset$Gebäudetyp, "</span>"))),
          p(HTML(paste("Baujahr:", "<span class='bold-vars'>", dataset$Baujahr, "</span>"))),
          p(HTML(paste("Oberirdische Geschosse:", "<span class='bold-vars'>", dataset$`Oberirdische Geschosse`, "</span>"))),
          p(HTML(paste("Unterirdische Geschosse:", "<span class='bold-vars'>", dataset$`Unterirdische Geschosse`, "</span>"))),
          p(HTML(paste("Zivilschutzraum:", "<span class='bold-vars'>", dataset$Zivilschutzraum, "</span>")))
        )
      ),

      # Card for "Heizung & Wasser"
      bslib::card(
        height = "auto",
        bslib::card_header(h2(title_2)),
        card_body(
          min_height = card_min_height,
          p(HTML(paste("Wärmeerzeuger Heizung 1:", "<span class='bold-vars'>", dataset$`Wärmeerzeuger Heizung 1`, "</span>"))),
          p(HTML(paste("Energiequelle Heizung 1:", "<span class='bold-vars'>", dataset$`Energiequelle Heizung 1`, "</span>"))),
          if (!is.na(dataset$`Wärmeerzeuger Heizung 2`) && dataset$`Wärmeerzeuger Heizung 2` != "") {
            p(HTML(paste("Wärmeerzeuger Heizung 2:", "<span class='bold-vars'>", dataset$`Wärmeerzeuger Heizung 2`, "</span>")))
          },
          if (!is.na(dataset$`Energiequelle Heizung 2`) && dataset$`Energiequelle Heizung 2` != "") {
            p(HTML(paste("Energiequelle Heizung 2:", "<span class='bold-vars'>", dataset$`Energiequelle Heizung 2`, "</span>")))
          },
          p(HTML(paste("Wärmeerzeuger Warmwasser 1:", "<span class='bold-vars'>", dataset$`Wärmeerzeuger Warmwasser 1`, "</span>"))),
          p(HTML(paste("Energiequelle Warmwasser 1:", "<span class='bold-vars'>", dataset$`Energiequelle Warmwasser 1`, "</span>"))),
          if (!is.na(dataset$`Wärmeerzeuger Warmwasser 2`) && dataset$`Wärmeerzeuger Warmwasser 2` != "") {
            p(HTML(paste("Wärmeerzeuger Warmwasser 2:", "<span class='bold-vars'>", dataset$`Wärmeerzeuger Warmwasser 2`, "</span>")))
          },
          if (!is.na(dataset$`Energiequelle Warmwasser 2`) && dataset$`Energiequelle Warmwasser 2` != "") {
            p(HTML(paste("Energiequelle Warmwasser 2:", "<span class='bold-vars'>", dataset$`Energiequelle Warmwasser 2`, "</span>")))
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
          dataset %>%
            select(Adresse),
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
          select(aWN, EWID, Stockwerk, `Lage Wohnung`, Zimmer, `Wohnfläche (m2)`, Küche),
        columns = list(
          aWN = colDef(name = "aWN", minWidth = 50),
          EWID = colDef(minWidth = 50),
          Stockwerk = colDef(name = "Stockwerk", minWidth = 100),
          `Lage Wohnung` = colDef(name = "Lage Wohnung", minWidth = 80),
          Zimmer = colDef(name = "Zimmer", minWidth = 60),
          `Wohnfläche (m2)` = colDef(name = "Wohnfläche (m2)"),
          Küche = colDef(name = "Küche")
        ),
        paginationType = "simple",
        language = reactableLang(
          noData = "Keine Einträge gefunden",
          pageNumbers = "{page} von {pages}",
          pageInfo = "{rowStart} bis {rowEnd} von {rows} Einträgen",
          pagePrevious = "\u276e",
          pageNext = "\u276f",
          pagePreviousLabel = "Vorherige Seite",
          pageNextLabel = "Nächste Seite"
        ),
        defaultPageSize = 10,
        fullWidth = TRUE
      )
    ),
    tags$div(
      class = "infoDiv",
      h5("Erklärungen"),
      p("aWN = amtliche Wohnungsnummer"),
      p("EGID = Eidgenössischer Gebäudeidentifikator"),
      p("EWID = Eidgenössischer Wohnungsidentifikator")
    )
  )
}
