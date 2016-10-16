
# This function performs some basic cleaning tasks whilst making minimal 
# assumptions about the nature of the text.

library(stringr)

clean_text <- function(x) {
  
  x %>% 
    str_to_lower %>% 
    str_replace_all("[^[:alnum:]]", " ") %>% 
    str_replace_all("\\s+", " ") %>% 
    str_replace_all("(^\\s+)|(\\s+$)", "")
  
}