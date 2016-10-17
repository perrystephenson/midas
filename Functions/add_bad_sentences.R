
# This function assumes a test set of 10 rows of Impact Case Study dataset.

library(stringr)
library(magrittr)

add_bad_sentences <- function(x) {
  
  x$ImpactDetails[1] %<>% 
    str_c(" This project awesome and people in Australia and America said it was awesome.")
  
  x$ImpactDetails[2] %<>% 
    str_c(" We worked with IBM and Microsoft and Apple and Google and lots of other companies.")
  
  x$ImpactDetails[3] %<>% 
    str_c(" We made friends and worked with people from the psychology department and the computer science department.")
  
  x$ImpactDetails[4] %<>% 
    str_c(" Everyone was sick at the start and now they are not sick at the end.")
  
  x$ImpactDetails[5] %<>% 
    str_c(" Lots of people were dying at the start and now less people are dying because of our project.")
  
  x$ImpactDetails[6] %<>% 
    str_c(" We got our project in the local newspaper and on television and everyone watched.")
  
  x$ImpactDetails[7] %<>% 
    str_c(" We tried to do something different to what everyone else was doing.")
  
  x$ImpactDetails[8] %<>% 
    str_c(" Every year many people get sick kidneys and it makes them die.")
  
  x$ImpactDetails[9] %<>% 
    str_c(" We came up with a new way of doing things that was better than the old way.")
  
  x$ImpactDetails[10] %<>% 
    str_c(" The university got lots of money from the government and from IBM and Microsoft.")
  
  return(x)
  
}
