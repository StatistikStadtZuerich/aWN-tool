# Authenticate
rsconnect::setAccountInfo(name = Sys.getenv("SHINY_ACC_NAME"),
                          token = Sys.getenv("TOKEN"),
                          secret = Sys.getenv("SECRET"))
# Deploy
rsconnect::deployApp(forceUpdate = TRUE,
                     appName = Sys.getenv("APP_NAME"),
                     appFiles = c(
                       # Add any additional files unique to your app here.
                       "R/",
                       "inst/",
                       "NAMESPACE",
                       "DESCRIPTION",
                       "app.R",
                       ".Rbuildignore"
                     ))
