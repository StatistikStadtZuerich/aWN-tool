renv::status()
source('data-raw/create_latest_data.R')
devtools::test()
source('dev/deploy.R')