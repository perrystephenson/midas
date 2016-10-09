# GloVe using text2vec
library(text2vec)

# Get the standard training set from the net
text8_file <- "~/text8"
if (!file.exists(text8_file)) {
  download.file("http://mattmahoney.net/dc/text8.zip", "~/text8.zip")
  unzip ("~/text8.zip", files = "text8", exdir = "~/")
}
wiki <- readLines(text8_file, n = 1, warn = FALSE)

# Create iterator over tokens
tokens <- space_tokenizer(wiki)
# Create vocabulary. Terms will be unigrams (simple words).
it <- itoken(tokens)
vocab <- create_vocabulary(it)

vocab <- prune_vocabulary(vocab, term_count_min = 5L)

# Use our filtered vocabulary
vectorizer <- vocab_vectorizer(vocab, 
                               # don't vectorize input
                               grow_dtm = FALSE, 
                               # use window of 5 for context words
                               skip_grams_window = 5L)
tcm <- create_tcm(it, vectorizer)

glove <- GlobalVectors$new(word_vectors_size = 100,
                           vocabulary = vocab,
                           x_max = 10L,
                           lambda = 1e-5)
glove$fit(tcm, n_iter = 50)

word_vectors <- glove$get_word_vectors()

# This works!
berlin <- word_vectors["paris", , drop = FALSE] - 
  word_vectors["france", , drop = FALSE] + 
  word_vectors["germany", , drop = FALSE]
cos_sim = sim2(x = word_vectors, y = berlin, method = "cosine", norm = "l2")
head(sort(cos_sim[,1], decreasing = TRUE), 5)

# This one not so much...
pound <- word_vectors["man", , drop = FALSE] - 
  word_vectors["king", , drop = FALSE] + 
  word_vectors["queen", , drop = FALSE]
cos_sim = sim2(x = word_vectors, y = pound, method = "cosine", norm = "l2")
head(sort(cos_sim[,1], decreasing = TRUE), 5)

# What is near perry? other names!
cos_sim = sim2(x = word_vectors,
               y = word_vectors["perry", , drop = FALSE],
               method = "cosine", norm = "l2")
head(sort(cos_sim[,1], decreasing = TRUE), 5)

cos_sim = sim2(x = word_vectors,
               y = word_vectors["sydney", , drop = FALSE],
               method = "cosine", norm = "l2")
head(sort(cos_sim[,1], decreasing = TRUE), 5)

# Standard evaluation set
questions_file <- '~/impactface/Data/questions-words.txt'
qlst <- prepare_analogy_questions(questions_file,
                                  rownames(word_vectors),
                                  verbose = T)
res <- check_analogy_accuracy(questions_list = qlst, 
                              m_word_vectors = word_vectors,
                              verbose = T)
