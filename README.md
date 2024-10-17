# aWN Tool - Amtliche Wohnungsnummer Tool

Shiny app for querying official apartment numbers (aWN - Amtliche Wohnungsnummern) and other related information such as energy sources, building details, and apartment sizes from the City of Zurich's Building and Apartment Registry. The data is obtained from the Open Data portal of the city of Zurich and is available here:

-   [building data](https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/resource/0dc7e4f2-09dd-4054-a14f-9ee8e6d5b2bb)
-   [entrance data](https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/resource/22094869-a3f4-44a1-a49d-a9d7dc80253a)
-   [apartement data](https://data.stadt-zuerich.ch/dataset/geo_gebaeude__und_wohnungsregister_der_stadt_zuerich__gwz__gemaess_gwr_datenmodell/resource/69aeb436-4718-4b56-a7b5-452f37a97147)

## Architecture

The aWN Tool is built using several modular components and helper functions such as **fct_get_data.R**, fct_get_card.R, fct_ssz_download_excel.R, and fct_get_infos.R. The main modules are as follows:

-   **Input Module (mod_input)**: This module contains all input widgets, such as address selection and filtering options. It returns data filtered according to the selected inputs (Address) and also passes the current inputs for the download functionality, ensuring that the Excel file is named with the correct address.

-   **Results Module (mod_results)**: This module is responsible for showing the main results to the user. It takes the filtered data from the input module and displays it using a reactable table.

-   **Download Module (mod_download)**: Handles the download functionality and gathers inputs from the results module, along with some static inputs (like the filename and Excel arguments), which are prepared in the main server logic.

Below is a visual represenation of the application's architecture:

``` mermaid
flowchart LR;
  mod_input-- filtered_building, filtered_apartment -->mod_results
  mod_input-- current_inputs -->main_server
  main_server-- filtered_building, filtered_apartment -->mod_results
  main_server-- download_ready_data -->mod_download
  subgraph mod_results
    mod_details
  end
  mod_input-- df_details_prefiltered -->mod_details
  mod_input-- filtered_building, filtered_apartment -->mod_download
```
