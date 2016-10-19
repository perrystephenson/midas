# This script prepares each of the datasets needed to run the live demo

root <- path.expand("~/impactface/")
set.seed(8888L)
library(dplyr)
library(magrittr)
library(stringr)
library(text2vec)
library(tidytext)

source(paste0(root, "Functions/load_ref_data.R"))
ref <- load_ref_data() %>% 
  select(CaseStudyId, UOA, ImpactType, Institution, Title, ImpactDetails)
in_test <- sample(1:nrow(ref), 10)
test <- ref[ in_test, ] # Leave 10 out for testing
ref  <- ref[-in_test, ] # Keep the rest
ref$Institution %<>%   str_replace_all("\\s+", " ") %>% 
  str_replace_all("(^\\s+)|(\\s+$)", "")
ref$Title %<>%         str_replace_all("\\s+", " ") %>% 
  str_replace_all("(^\\s+)|(\\s+$)", "")
ref$ImpactDetails %<>% str_replace_all("\\s+", " ") %>% 
  str_replace_all("(^\\s+)|(\\s+$)", "")

tidy_ref <- unnest_tokens(ref, Sentence, ImpactDetails, "sentences", to_lower=F)

source(paste0(root, "Functions/fit_glove_model.R"))
tmp <- fit_glove_model(ref$ImpactDetails, 75, 5) 
glove <- tmp[[1]]
vocab <- tmp[[2]]
rm(tmp)
word_vectors <- glove$get_word_vectors()

saveRDS(glove, "~/impactface/webapp/data/glove.rds")
saveRDS(vocab, "~/impactface/webapp/data/vocab.rds")
saveRDS(word_vectors, "~/impactface/webapp/data/word_vectors.rds")

source(paste0(root, "Functions/fit_tfidf.R"))
tfidf <- fit_tfidf(tidy_ref$Sentence, vocab)
source(paste0(root, "Functions/get_sentence_vectors.R"))
sentence_vectors <- get_sentence_vectors(sentences = tidy_ref$Sentence, 
                                         vocab = vocab, 
                                         transform = tfidf, 
                                         wv = word_vectors)

saveRDS(tfidf, "~/impactface/webapp/data/tfidf.rds")
#saveRDS(sentence_vectors, "~/impactface/webapp/data/sentence_vectors.rds")
write.csv(test, "~/impactface/webapp/data/test_sentences.csv")

average_sentence <- colMeans(as.matrix(sentence_vectors))
saveRDS(average_sentence, "~/impactface/webapp/data/average_sentence.rds")

# Calculate distances from corpus
global_distances <- 
  dist2(x = as.matrix(sentence_vectors), y = t(as.matrix(average_sentence)), 
        method = "euclidean", norm = "l2")[,1]

thresholds <- quantile(global_distances, probs = c(0.9, 0.95))
saveRDS(thresholds, "~/impactface/webapp/data/thresholds.rds")
