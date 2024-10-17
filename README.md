# aWN Tool - Amtliche Wohnungsnummer Tool

Shiny app for querying official apartment numbers (aWN - amtliche WohnungsNummern) and other information such as energy sources, building details, and apartment sizes from the City of Zurich's Building and Apartment Registry. The data is obtained from the [Open Data Catalogue](https://data.stadt-zuerich.ch/) of the city of Zurich and is

-   [building data](https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/resource/0dc7e4f2-09dd-4054-a14f-9ee8e6d5b2bb)
-   [entrance data](https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/resource/22094869-a3f4-44a1-a49d-a9d7dc80253a)
-   [apartement data](https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/resource/69aeb436-4718-4b56-a7b5-452f37a97147)

## Architecture

The aWN Tool is built using several modular components and helper functions such as fct_get_card.R, fct_ssz_download_excel.R, and fct_get_infos.R. The main modules are as follows:

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
  mod_input -- "address" --> app_server
  app_server -- "filtered_building, filtered_apartment" --> mod_results
  mod_results --> "Results in App"
  app_server -- "filtered_building, filtered_apartment" --> mod_download
  mod_download --> "Excel"
```
