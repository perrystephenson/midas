
# This function calculates a position in the m-dimensional GloVe model space for
# any given sentence.

library(text2vec)

get_sentence_vectors <- function(sentences, vocab, transform, wv) {
  
  iterator <- 
    sentences %>% 
    str_to_lower() %>% 
    str_replace_all("[^[:alnum:]]", " ") %>% 
    str_replace_all("\\s+", " ") %>% 
    str_replace_all("(^\\s+)|(\\s+$)", "") %>%
    word_tokenizer() %>% 
    itoken()

  vectorizer <- vocab_vectorizer(vocab)
  dtm <- create_dtm(iterator, vectorizer)

  dtm_tfidf <- transform(dtm, transform)
  sentence_vectors <- dtm_tfidf %*% wv
}