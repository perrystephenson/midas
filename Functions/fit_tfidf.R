
# This function fits a tf-idf transform to the data and returns the fit object.
# It does not modify the input data.

library(text2vec)

fit_tfidf <- function(sentence, vocab) {
  tokens <- 
    sentence %>% 
    str_to_lower() %>% 
    str_replace_all("[^[:alnum:]]", " ") %>% 
    str_replace_all("\\s+", " ") %>% 
    str_replace_all("(^\\s+)|(\\s+$)", "") %>% 
    word_tokenizer()
  it <- itoken(tokens)
  vectorizer <- vocab_vectorizer(vocab)
  dtm <- create_dtm(it, vectorizer)
  tfidf <- TfIdf$new(sublinear_tf = TRUE)
  tfidf$verbose <- FALSE
  tfidf$fit(dtm)
  return(tfidf)
}