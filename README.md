# OpenAthensAPIs
R code for getting data from the OpenAthens APIs.

Note: The reporting API requires a separate purchase for it to be enabled.
If it's not enabled, then the API call will return the HTTP Response code "403".

## Reporting API
Statistics can be harvested by running the file *OpenAthens_ReportingAPI.R*.

Note: You'll need to create the file "config.csv" beforehand - see "config_EXAMPLE.csv".

The config file has the following fields:

- **api_key**:    You can get this from [https://admin.openathens.net/](https://admin.openathens.net/) under *MANAGEMENT* > *API KEYS*
- **end_point**:  For the reporting API its "https://reports.openathens.net/api/v1/"
- **domain**:     This is your company's website domain.
- **query**:      I've included a very basic query in the example config file. See here for further info on building queries [parameters](https://docs.openathens.net/libraries/fetching-statistics-reports-via-the-api).

Files are output in .csv format, and will have the name "OpenAthensReport_" + the system time it was created.