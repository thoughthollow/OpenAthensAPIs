######
# TITLE: How to get statistical data from OpenAthens using R
#
# More information on fetching statistical reports from the OpenAthens reporting API can be found here:
# https://docs.openathens.net/libraries/fetching-statistics-reports-via-the-api
######


### Setup ###
# Load Packages
{
  library(tidyverse)
  library(httr)
  library(jsonlite)
}

# Create "output" sub-directory if it doesn't exist
if (!dir.exists("output")) {
  dir.create("output")
}

# Get the configuration info
if (!file.exists("config.csv")) {
  writeLines("You need to create and populate config.csv!\nSee: config_EXAMPLE.csv")
} else {
    config <- read_csv("config.csv",
                       locale = locale(encoding = "UTF-8"),
                       trim_ws=TRUE)
    
    for (i in 1:ncol(config)) {
      assign(names(config)[i], as.character(config[,i]))
    }
    
    rm(i)
}
### Setup End ###


# Call the API to tell it to prepare the report
prepreport <- GET(url = str_interp("${end_point}${domain}/${query}"),
                  add_headers("Content-Type" = "application/vnd.eduserv.iam.admin.organisation-v1+json",
                              "Authorization" = str_interp("OAApiKey ${api_key}")
                  )
)

if (status_code(prepreport) != 200) {
  print(
    paste("Error code",status_code(prepreport))
  )
} else {
  # Next we need the "href" value from the successful call to do another call to get the statistical data
  # (The initial response is in JSON format, so we dig down until we find "href")
  reportURL <- content(prepreport)$links %>%
    data.frame()
  reportURL <- reportURL[1,1]
  
  # Wait a bit in case it takes some time for OpenAthens to create the report
  Sys.sleep(15)
  
  # Call the API again
  result <- GET(url = reportURL,
                add_headers("Content-Type" = "application/vnd.eduserv.iam.admin.organisation-v1+json",
                            "Authorization" = str_interp("OAApiKey ${api_key}")
                )
  )
  
  # Convert the body to a dataframe
  df <- read_csv(content(result, "text"))
  
  # write the results to a .csv file
  write_csv(df, file=paste0("output/OpenAthensReport_",
                            format(Sys.time(), "%Y-%m-%d_%H.%M"),
                            ".csv"))
}
