# aWN Tool - Amtliche Wohnungsnummer

[Shiny app](https://www.stadt-zuerich.ch/de/politik-und-verwaltung/statistik-und-daten/publikationen-und-dienstleistungen/register-und-datawarehouse/gebaeuderegister-wohnungsregister/amtliche-wohnungsnummer.html) for querying official apartment numbers (aWN - amtliche WohnungsNummern) and additional information such as primary and secondary energy sources, building details, and apartment sizes from the City of Zurich's [Building and Apartment Registry](https://www.stadt-zuerich.ch/de/politik-und-verwaltung/statistik-und-daten/publikationen-und-dienstleistungen/register-und-datawarehouse/gebaeuderegister-wohnungsregister.html). The data is sourced from the [Open Data Catalogue](https://data.stadt-zuerich.ch/) of the City of Zurich and is updated daily.

## App's Architecture

The aWN Tool is built using several modular components and helper functions. The main modules are as follows:

-   `app_ui` sets up the UI layout, including the `mod_input_ui`, results (`mod_results_ui`), and download buttons (`mod_download_ui`).

-   `mod_input_ui` handles address input. Its server function, `mod_input_server`, return filtered data based on the selected address.

-   `app_server` reacts to the action button click:

    -   Filtered input: The `mod_input_server` module filters building and apartment data.

    -   Result display: Depending on valid input, it shows the `mod_result_ui` and `mod_download_ui`.

    -   Warning: If the address is not found, a warning UI is rendered.

-   `mod_result_server` renders the building and apartment based on filtered input.

-   `mod_download_server` enables downloading filtered data (building and apartment).

Below is a visual representation of the application's architecture:

``` mermaid
flowchart LR
  mod_input -->|address| app_server
  app_server -->|filtered_building, filtered_apartment| mod_results
  mod_results -->|Result| App
  app_server -->|filtered_building, filtered_apartment| mod_download
  mod_download -->|Result| Download
```
