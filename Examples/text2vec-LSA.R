# LSA using text2vec
library(stringr)
library(text2vec)

# Import the movie review data
data("movie_review")

# Train/test split
in_train <- sample(1:nrow(movie_review), 0.8*nrow(movie_review))
movie_review_train <- movie_review[in_train, ]
movie_review_test <- movie_review[-in_train, ]

# Text preparation function
prep_fun <- function(x) {
  x %>% 
    # make text lower case
    str_to_lower %>% 
    # remove non-alphanumeric symbols
    str_replace_all("[^[:alnum:]]", " ") %>% 
    # collapse multiple spaces
    str_replace_all("\\s+", " ")
}

# Text preparation
movie_review_train$review <- prep_fun(movie_review_train$review)

# Create a token iterator
it <- itoken(movie_review_train$review)

# Create a vocabulary
v <- create_vocabulary(it) %>% 
  prune_vocabulary(doc_proportion_max = 0.1, term_count_min = 5)

# Specify a vectorizer
vectorizer <- vocab_vectorizer(v)

# Create a DTM
dtm <- create_dtm(it, vectorizer)

# Creating some objects
tfidf <- TfIdf$new()
lsa <- LSA$new(n_topics = 10)

# Transforming the data with TF-IDF and LSA
dtm_tfidf_lsa <- 
  dtm %>% 
  fit_transform(tfidf) %>% 
  fit_transform(lsa)

# Apply the transformations to unseen data
new_data <- movie_review_test
new_data_dtm_tfidf_lsa <- 
  new_data$review %>% 
  itoken(preprocessor = prep_fun) %>% 
  create_dtm(vectorizer) %>% 
  transform(tfidf) %>% 
  transform(lsa)
head(new_data_dtm_tfidf_lsa)

