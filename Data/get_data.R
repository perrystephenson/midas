library(refimpact)

get_data <- function() {
  
  # Get the list of Units of Assessment to iterate over
  uoa_table <- get_units_of_assessment()
  uoa_list <- uoa_table$ID
  
  # Iterate through the list
  for (i in uoa_list) {
    message("Retrieving data for UoA ", i)
    if (i == 1) {
      ref_corpus <- get_case_studies(UoA = as.numeric(i))
    } else {
      ref_corpus <- rbind(ref_corpus, get_case_studies(UoA = as.numeric(i)))
    }
  }
  
  return(ref_corpus)
}

# Call the function to download the dataset
ref_corpus <- get_data()

# That function takes ages to run, so it's worth saving the data to file to load
# it more quickly in future
saveRDS(ref_corpus, "~/ref_data.rds")
