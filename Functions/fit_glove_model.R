
# This function fits a GloVe model using the provided text vector. 

library(text2vec)
library(stringr)

fit_glove_model <- function(x, dimension = 50, skip_window = 5L) {
  
  iterator <- 
    x %>% 
    str_to_lower %>% 
    str_replace_all("[^[:alnum:]]", " ") %>% 
    str_replace_all("\\s+", " ") %>% 
    str_replace_all("(^\\s+)|(\\s+$)", "") %>% 
    word_tokenizer() %>% 
    itoken()
  
  vocab <- 
    create_vocabulary(iterator) %>% 
    prune_vocabulary(term_count_min = 5L)
  
  vectorizer <- 
    vocab_vectorizer(vocab, grow_dtm = FALSE, skip_grams_window = skip_window)
  
  tcm <- create_tcm(iterator, vectorizer)
  
  # This is an R6 class object, so it doesn't behave like most other things in 
  # R. You should definitely read the text2vec documentation before playing with
  # these bits.
  glove <- GlobalVectors$new(word_vectors_size = dimension,
                             vocabulary = vocab,
                             x_max = 10L,
                             lambda = 1e-5,
                             shuffle=T)
  glove$fit(tcm, n_iter = 50)
  
  return(list(glove, vocab))
  
}