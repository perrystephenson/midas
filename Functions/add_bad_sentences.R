
# This function assumes a test set of 10 rows of Impact Case Study dataset.

library(stringr)
library(magrittr)

add_bad_sentences <- function(x) {
  
  x$ImpactDetails[1] %<>% 
    str_c(" My analysis was awesome and had a huge impact on the world.")
  
  x$ImpactDetails[2] %<>% 
    str_c(" Other universities really liked what we did and now they want to do it too.")
  
  x$ImpactDetails[3] %<>% 
    str_c(" We worked with people from the biology, psychology and computer science departments.")
  
  x$ImpactDetails[4] %<>% 
    str_c(" Many of our patients said that they felt better.")
  
  x$ImpactDetails[5] %<>% 
    str_c(" A lot of people used to die and now less people die.")
  
  x$ImpactDetails[6] %<>% 
    str_c(" We got our project in the local newspaper and on television.")
  
  x$ImpactDetails[7] %<>% 
    str_c(" We had a really big team and everyone did something different.")
  
  x$ImpactDetails[8] %<>% 
    str_c(" Every year lots of people are sick with a sleep disease.")
  
  x$ImpactDetails[9] %<>% 
    str_c(" We came up with a new way of doing things that was better than the old way.")
  
  x$ImpactDetails[10] %<>% 
    str_c(" The University of Technology Sydney is the best university in the world.")
  
  return(x)
  
}
