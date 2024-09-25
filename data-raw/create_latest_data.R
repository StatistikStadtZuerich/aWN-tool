# script to get the latest data from ogd and save it locally
# run locally, and will be run also in the deployment pipeline
#
# when running locally: load all as well
pkgload::load_all(helpers = FALSE, attach_testthat = FALSE)

# get data and make Data Frames
df_main <- get_data()

usethis::use_data(df_main,
                  overwrite = TRUE,
                  internal = TRUE
)
