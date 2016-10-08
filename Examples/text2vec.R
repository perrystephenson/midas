# text2vec examples from vignette, adapted to avoid data.table and use caret
library(text2vec)
library(caret)
library(glmnet)
library(dplyr)

# Multicore
library(doMC)
registerDoMC(8)

data("movie_review")

# Create train/test split
all_ids <- movie_review$id
train_rows <- sample(seq_along(all_ids), 4000)
train <- movie_review[train_rows,]
test <- movie_review[-train_rows,]

# Create an iterator for the training dataset
it_train <- itoken(train$review, 
                   preprocessor = tolower, 
                   tokenizer = word_tokenizer, 
                   ids = train$id)

# Generate a vocabulary by iterating through the corpus
vocab <- create_vocabulary(it_train)

# Take a look at the vocab
vocab

# Create a Document Term Matrix
vectorizer <- vocab_vectorizer(vocab)
dtm_train <- create_dtm(it_train, vectorizer)

# Check the dimension (4,000 rows and approx 35,500 columns)
dim(dtm_train)

# This will be SLOW - 35,000 columns is a bit much. Commented out for now.
# tune <- train(x = dtm_train, 
#               y = as.factor(train$sentiment),
#               method = "glmnet",
#               trControl = trainControl(method = "repeatedcv",
#                                        number = 5,
#                                        repeats = 1,
#                                        search = "random",
#                                        verboseIter = TRUE),
#               tuneLength = 10)

# Predict the unseen test set
it_test <- test$review %>% 
  tolower %>% 
  word_tokenizer %>% 
  itoken(ids = test$id)
dtm_test <- create_dtm(it_test, vectorizer)
# preds <- predict(tune, dtm_test, type = "raw")

# Check the accuracy
# cm1 <- confusionMatrix(test$sentiment, preds)


# Remove stop words and infrequent terms to make the DTM a bit more manageable
stop_words <- c("i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "your", "yours")
vocab <- create_vocabulary(it_train, stopwords = stop_words)
pruned_vocab <- prune_vocabulary(vocab, 
                                term_count_min = 10, 
                                doc_proportion_max = 0.5,
                                doc_proportion_min = 0.001)
vectorizer <- vocab_vectorizer(pruned_vocab)

# create dtm_train with new pruned vocabulary vectorizer
dtm_train <- create_dtm(it_train, vectorizer)

# Check the dimension (4,000 rows and approx 6,500 columns)
dim(dtm_train)

# This should be much faster!
tune <- train(x = dtm_train, 
              y = as.factor(train$sentiment),
              method = "glmnet",
              trControl = trainControl(method = "repeatedcv",
                                       number = 5,
                                       repeats = 1,
                                       search = "random",
                                       verboseIter = TRUE),
              tuneLength = 10)

# Make a new (narrower) DTM for the test set
dtm_test <- create_dtm(it_test, vectorizer)

# Check the accuracy
preds <- predict(tune, dtm_test, type = "raw")
cm2 <- confusionMatrix(test$sentiment, preds)

# Basically the same accuracy. Good! Now let's try adding 2-grams
vocab <- create_vocabulary(it_train, ngram = c(1L, 2L))
vocab <- vocab %>% prune_vocabulary(term_count_min = 10, 
                                   doc_proportion_max = 0.5)
bigram_vectorizer <- vocab_vectorizer(vocab)
dtm_train <- create_dtm(it_train, bigram_vectorizer)

# Train again using the unigrams and 2-grams
tune <- train(x = dtm_train, 
              y = as.factor(train$sentiment),
              method = "glmnet",
              trControl = trainControl(method = "repeatedcv",
                                       number = 5,
                                       repeats = 1,
                                       search = "random",
                                       verboseIter = TRUE),
              tuneLength = 10)

# Check the accuracy
dtm_test <- create_dtm(it_test, bigram_vectorizer)
preds <- predict(tune, dtm_test, type = "raw")
cm3 <- confusionMatrix(test$sentiment, preds)

# Apply TF-IDF transform
tfidf <- TfIdf$new()
dtm_train_tfidf <- fit_transform(dtm_train, tfidf)

# Train again using the unigrams and 2-grams
tune <- train(x = dtm_train_tfidf, 
              y = as.factor(train$sentiment),
              method = "glmnet",
              trControl = trainControl(method = "repeatedcv",
                                       number = 10,
                                       repeats = 1,
                                       search = "random",
                                       verboseIter = TRUE),
              tuneLength = 20)

# Check the accuracy
dtm_test_tfidf  <- transform(dtm_test, tfidf)
preds <- predict(tune, dtm_test_tfidf, type = "raw")
cm4 <- confusionMatrix(test$sentiment, preds)
