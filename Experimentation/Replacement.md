Proof of Concept - Replacement
================

This script aims to prove the following concepts:

1.  For an unseen sentence, some alternative sentences with similar meaning from the training corpus can be suggested as replacement inspiration
2.  The replacement sentences which are suggested will not be outliers, or will be less of an outlier than the original sentence.

Setup
-----

``` r
library(text2vec)
library(stringr)
library(tibble)
library(dplyr)
```

A reasonable GloVe model was trained in a previous markdown document, so we can quickly re-import the relevant objects here.

``` r
import <- readRDS("~/markdown_cache.rds")
ref              <- import[[1]]
tidy_ref         <- import[[2]]
sentence_vectors <- import[[3]]
word_vectors     <- import[[4]]
tfidf            <- import[[5]]
vocab            <- import[[6]]
corpus_dtm       <- import[[7]]
```

Generating Replacement Sentences
--------------------------------

The central idea here is that given a corpus of "acceptable sentences", a new unseen sentence can be analysed for similarity with those existing acceptable sentences, and suitable alternatives can be proposed automatically.

The first step in this workflow is to transform an unseen sentence and assess its similarity to the existing corpus. This isn't required for this experiment, but it is required for the end-to-end pipeline so it's worth testing now.

The sentence to be tested will be:

> My analysis was awesome and had a huge impact on the world.

This sentence is a good candidate because it has a meaning consistent with the other impact studies, but it is written in a style incompatible with the existing corpus.

``` r
prepare_text <- function(x) {
  x %>% 
  str_to_lower %>% 
  str_replace_all("[^[:alnum:]]", " ") %>% 
  str_replace_all("\\s+", " ")
}
unseen_sentence <- "My analysis was awesome and had a huge impact on the world."
unseen_dtm <- unseen_sentence %>% 
  prepare_text() %>% 
  word_tokenizer() %>% 
  itoken() %>% 
  create_dtm(vocab_vectorizer(vocab)) 
unseen_tfidf <- transform(unseen_dtm, tfidf)
unseen_sen_vector <- unseen_tfidf %*% word_vectors
dist2(x = t(colMeans(as.matrix(sentence_vectors))), 
      y = as.matrix(unseen_sen_vector), 
      method = "euclidean", norm = "l2")[,1]
```

    ## [1] 1.353721

This is a great result! The obviously bad sentence is **further away** from the average sentence in the corpus than **any** sentence in the corpus. This goes further towards proving the assumptions in the previous markdown document are viable.

The next challenge is to identify similar sentences which can be used as potential replacements. The first way to try this is with the euclidean distance measure, looking for the three closest sentences.

``` r
distances <- dist2(x = as.matrix(sentence_vectors), 
                   y = as.matrix(unseen_sen_vector), 
                   method = "euclidean", norm = "l2")[,1]
tidy_ref$unseen_distance <- distances
tidy_ref %>% arrange(unseen_distance) %>% 
  select(text) %>% 
  head(20)
```

    ## # A tibble: 20 × 1
    ##        text
    ##       <chr>
    ## 1     [...]
    ## 2     [...]
    ## 3     [...]
    ## 4     [...]
    ## 5     [...]
    ## 6     [...]
    ## 7     [...]
    ## 8     (...)
    ## 9     ir6].
    ## 10   [...].
    ## 11    [...]
    ## 12    [...]
    ## 13    [...]
    ## 14    [...]
    ## 15    [...]
    ## 16    (...)
    ## 17    [...]
    ## 18 metsec).
    ## 19    [...]
    ## 20        `

This is clearly rubbish - I've manually searched through the 200 closest "sentences" and they're all just as bad. One solution to this is to do some text cleaning when importing the data, and that might well be something worth doing. However, in an effort to keep this as generalised and automatic as possible, I'm going to try using the very exciting "Word Mover's Distance" algorithm as an alternative measure of distance between the sentences. This uses the GloVe word vectors as an argument and works directly on the un-edited sentences, so it considers a lot more information than standard euclidean distance. Let's give it a go!

``` r
rwmd <- RelaxedWordMoversDistance$new(word_vectors)
rwmd$verbose <- FALSE
tidy_ref$rwmd_distance <- dist2(corpus_dtm, unseen_dtm, 
                                method = rwmd, 
                                norm = "none")[,1]
suggestions <- tidy_ref %>% 
  arrange(rwmd_distance) %>% 
  head(3)
suggestions$text
```

    ## [1] "impact on policy     the research associated with the development and evaluation of assist has       had a substantial impact on policy."                                            
    ## [2] "the wider impact of this research       has been acknowledged within the museum world both in the uk and abroad:       `the project had a transformatory effect on the v&amp;a."     
    ## [3] "in addition to the impact on public policy and its resultant impact on        health and wellbeing, this work        has had a significant impact on both society and practitioners."

This is amazing! I haven't had to do any data cleaning at all to get this to work, the Relaxed Word Mover's Distance is doing all of the work for me!

It's worth quickly checking that these three suggestions are closer to the average sentence than the original one we started with.

``` r
tidy_ref %>% arrange(rwmd_distance) %>% 
  select(global_distance) %>% 
  head(3)
```

    ## # A tibble: 3 × 1
    ##   global_distance
    ##             <dbl>
    ## 1       0.4747143
    ## 2       0.4512479
    ## 3       0.4907434

Fantastic! With this all sorted, I'm ready to start building a proof-of-concept.
