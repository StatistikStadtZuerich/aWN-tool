renv::status()
source('data-raw/create_latest_data.R')
# run tests for local package but with reporther that throws an error upon failure
testthat::test_local(reporter = testthat::check_reporter())
source('dev/deploy.R')