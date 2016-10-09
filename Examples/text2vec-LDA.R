# LDA using text2vec
library(text2vec)
data("movie_review")

tokens <- movie_review$review %>% 
  tolower %>% 
  word_tokenizer

it <- itoken(tokens, ids = movie_review$id)
v <- create_vocabulary(it) %>% 
  prune_vocabulary(term_count_min = 10, doc_proportion_max = 0.2)
vectorizer <- vocab_vectorizer(v)
dtm <- create_dtm(it, vectorizer, type = "lda_c")

lda_model <- 
  LDA$new(n_topics = 10, vocabulary = v, 
          doc_topic_prior = 0.1, topic_word_prior = 0.01)
doc_topic_distr <- 
  lda_model$fit_transform(dtm, n_iter = 1000, convergence_tol = 0.01, 
                          check_convergence_every_n = 10)

lda_model$plot()

