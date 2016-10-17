
# This function loads the data by either:
# - loading the RDS file if it exists, or
# - loading the data from the REF Impact Case Study Database API (using the
#   refimpact package)

load_ref_data <- function() {
  if (file.exists("~/ref_data.rds")) {
    return(readRDS("~/ref_data.rds"))
  } else {
    if (require(refimpact)) {
      source("Data/get_data.R")
      message("Loading data from source - this could take a few minutes.")
      return(get_data())
    } else {
      stop("You need to install the `refimpact` package from CRAN to load this dataset.")
    }
  }
}