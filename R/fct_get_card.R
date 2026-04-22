#' Render info items for context box
#'
#' @description Generates a formatted HTML string containing explanatory information
#' for either apartments or buildings. The content is returned as a single
#' HTML string with line breaks, suitable for display in UI elements such
#' as context boxes.
#'
#' @param type Character string indicating which set of information to return.
#'   Must be one of `"apartment"` or `"building"`. Defaults to `"apartment"`.
#'
#' @return An HTML string (via \code{HTML()}) containing formatted info lines.
#'
#' @noRd
get_info_items <- function(type = c("apartment", "building")) {
  type <- match.arg(type)
  items <- switch(type,
    apartment = c(
      paste0("<span class='bold-text'>Anzahl Geschosse</span>: umfasst unter- und oberirdische Geschosse"),
      paste0("<span class='bold-text'>Anzahl Zimmer</span>: halbe Zimmer werden abgerundet"),
      paste0("<span class='bold-text'>aWN</span>: amtliche Wohnungsnummer"),
      paste0("<span class='bold-text'>EGID</span>: Eidgenössischer Gebäudeidentifikator"),
      paste0("<span class='bold-text'>EWID</span>: Eidgenössischer Wohnungsidentifikator")
    ),
    building = c(
      paste0("<span class='bold-text'>Anzahl Geschosse</span>: umfasst unter- und oberirdische Geschosse"),
      paste0("<span class='bold-text'>EGID</span>: Eidgenössischer Gebäudeidentifikator")
    )
  )
  HTML(paste(items, collapse = "<br>"))
}

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
                              title_2 = "Informationen zur Energie",
                              stadtplan_url = NULL) {
  
  # Define the unwanted values for each variable
  unwanted_GWAERZH2Lang <- c("Kein Wärmeerzeuger (nicht beheiztes Gebäude)", "Keine Angabe", "")
  unwanted_GENH2Lang <- c("Kein Energieträger", "Keine Angabe", "")
  unwanted_GWAERZW2Lang <- c("Keine Angabe", "Kein Wärmeerzeuger (nicht beheiztes Gebäude)", "")
  unwanted_GENW2Lang <- c("Kein Energieträger", "Keine Angabe", "")
  
  # Make the card
  tagList(
    br(),
    h2(paste0(dataset$Adresse, " (EGID ", dataset$EGID, ")")),
    if (!is.null(stadtplan_url)) {tags$p(
      tags$a(
        href = stadtplan_url,
        target = "_blank",
        "Stadtplan öffnen ",
        icons_stzh()("external-link")
      )
    )},

    # Wrap the cards in a two-column layout
    layout_column_wrap(
      width = 1 / 2,

      # Card for "Allgemeine Informationen"
      card(
        height = "auto",
        card_header(h3(title_1)),
        card_body(
          min_height = card_min_height,
          tags$ul(class = "dashed-list",
            HTML(paste("Gebäudetyp:", "<span class='bold-text'>", dataset$Gebäudetyp, "</span>")),
          ),
          tags$ul(class = "dashed-list",
            HTML(paste("Baujahr:", "<span class='bold-text'>", dataset$Baujahr, "</span>"))
          ),
          tags$ul(class = "dashed-list",
            HTML(paste("Anzahl Geschosse:", "<span class='bold-text'>", dataset$Geschosse, "</span>"))
          ),
          tags$ul(class = "dashed-list",
            HTML(paste("Zivilschutzraum:", "<span class='bold-text'>", dataset$Zivilschutzraum, "</span>"))
          )
        )
      ),

      # Card for "Heizung & Wasser"
      card(
        height = "auto",
        card_header(h3(title_2)),
        card_body(
          min_height = card_min_height,
            tags$ul(class = "dashed-list",
                    HTML(paste("Wärmeerzeuger Heizung 1:", "<span class='bold-text'>", dataset$`Wärmeerzeuger Heizung 1`, "</span>"))),
            tags$ul(class = "dashed-list",
                    HTML(paste("Energiequelle Heizung 1:", "<span class='bold-text'>", dataset$`Energiequelle Heizung 1`, "</span>"))),
            if (!is.na(dataset$`Wärmeerzeuger Heizung 2`) && 
                !(dataset$`Wärmeerzeuger Heizung 2` %in% unwanted_GWAERZH2Lang)) {
              tags$ul(class = "dashed-list",
                      HTML(paste("Wärmeerzeuger Heizung 2:", "<span class='bold-text'>", dataset$`Wärmeerzeuger Heizung 2`, "</span>")))
            },
            if (!is.na(dataset$`Energiequelle Heizung 2`) && 
                !(dataset$`Energiequelle Heizung 2` %in% unwanted_GENH2Lang)) {
              tags$ul(class = "dashed-list",
                      HTML(paste("Energiequelle Heizung 2:", "<span class='bold-text'>", dataset$`Energiequelle Heizung 2`, "</span>")))
            },
            tags$ul(class = "dashed-list",
                    HTML(paste("Wärmeerzeuger Warmwasser 1:", "<span class='bold-text'>", dataset$`Wärmeerzeuger Warmwasser 1`, "</span>"))),
            tags$ul(class = "dashed-list",
                    HTML(paste("Energiequelle Warmwasser 1:", "<span class='bold-text'>", dataset$`Energiequelle Warmwasser 1`, "</span>"))),
            if (!is.na(dataset$`Wärmeerzeuger Warmwasser 2`) && 
                !(dataset$`Wärmeerzeuger Warmwasser 2` %in% unwanted_GWAERZW2Lang)) {
              tags$ul(class = "dashed-list",
                      HTML(paste("Wärmeerzeuger Warmwasser 2:", "<span class='bold-text'>", dataset$`Wärmeerzeuger Warmwasser 2`, "</span>")))
            },
            if (!is.na(dataset$`Energiequelle Warmwasser 2`) && 
                !(dataset$`Energiequelle Warmwasser 2` %in% unwanted_GENW2Lang)) {
              tags$ul(class = "dashed-list",
                      HTML(paste("Energiequelle Warmwasser 2:", "<span class='bold-text'>", dataset$`Energiequelle Warmwasser 2`, "</span>")))
            }
        )
      )
    )
  )
}

#' Entrance Info Box
#'
#' @description Renders an info box for buildings with multiple entrances,
#'   including a reactable listing the other addresses.
#'
#' @param dataset Data Frame with Building Infos (filtered to other entrances)
#' @param title Title of the Info Box
#' @param text Text of the Info Box
#'
#' @return tagList with sszInfoBox and reactable
#'
#' @noRd
get_entrance_card <- function(dataset, title = "Info", 
                              text = "Dieses Gebäude hat mehrere Eingänge mit unterschiedlichen Adressen. Wenn Sie Wohnungsinformationen zu einem der untenstehenden Eingänge suchen, geben Sie diese Adresse ins Suchfeld ein.") {
  sszInfoBox(
    title = title,
    text = tagList(
      p(text),
      tags$ul(class = "dashed-list",
        lapply(dataset$Adresse, function(addr) tags$li(HTML(addr)))
      )
    ),
    icon = icons_stzh()("info-help-filled")
  )
}


#' Apartment Infos as Reactable
#'
#' @description Function to render apartment infos as a reactable table
#'
#' @param dataset Data Frame with Apartment Infos
#' @param progress Integer flag: 1 if apartments under construction exist, 0 otherwise
#' @param title Title displayed above the table
#'
#' @return tagList with heading and reactable
#'
#' @noRd
get_apartment_card <- function(dataset = sorted_apartments,
                               progress = 0,
                               title = "Informationen zu den Wohnungen") {
  # Info Text
  info_text <- if (progress == 0) {
    NULL
  } else if (progress == 1) {
    p("Das Gebäude enthält auch neue Wohnungen, die noch im Bau sind.")
  }

  tagList(
    br(),
    h3(title),
    info_text,
    reactable(
      dataset |> 
        select(aWN, EWID, Stockwerk, `Lage Wohnung`, Zimmer, `Wohnfläche (m2)`, Maisonette, Küche),
      columns = list(
        aWN = colDef(name = "aWN", minWidth = 45),
        EWID = colDef(minWidth = 50, align = "left"),
        Stockwerk = colDef(name = "Stockwerk", minWidth = 75),
        `Lage Wohnung` = colDef(name = "Lage", minWidth = 50),
        Zimmer = colDef(name = "Zimmer", minWidth = 50),
        `Wohnfläche (m2)` = colDef(name = "Wohnfläche (m2)", minWidth = 85),
        Maisonette = colDef(name = "Maisonette", minWidth = 79),
        Küche = colDef(name = "Küche", minWidth = 52)
      ),
      paginationType = "simple",
      class = "table-striped",
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
  )
}
