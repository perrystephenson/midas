Implementation
================

This document will string together each of the key implementation steps and demonstrate the effectiveness of the end-to-end system as a static analysis. The majority of the implementation is inside functions in the "Functions" folder of this repository, which allows the code to be easily re-used in the event I get time to build a live demonstration system. These functions should also minimise the time-to-implementation for anyone wishing to apply this technique to a new dataset.

If you have cloned this repository and you are attempting to run this code on your own machine, make sure you set your working directory to the root folder of the repository: `setwd("<repo root>")`.

Setup and Packages
------------------

``` r
setwd("~/impactface")
set.seed(2016L)
library(dplyr)
library(ggplot2)
library(magrittr)
library(refimpact)
library(stringr)
library(text2vec)
library(tibble)
library(tidytext)
```

Data Import
-----------

The data will be either imported from an RDS file on disk, or directly from the REF Impact Case Study Database using the `refimpact` package. We will also do some very basic cleaning by removing superfluous whitespace from the text fields.

``` r
source("Functions/load_ref_data.R")
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
glimpse(ref)
```

    ## Observations: 6,627
    ## Variables: 6
    ## $ CaseStudyId   <chr> "1855", "1856", "2582", "2613", "2703", "2728", ...
    ## $ UOA           <chr> "Clinical Medicine", "Clinical Medicine", "Clini...
    ## $ ImpactType    <chr> "Health", "Technological", "Health", "Health", "...
    ## $ Institution   <chr> "University of East Anglia", "University of East...
    ## $ Title         <chr> "Influencing guidelines on management of hyperte...
    ## $ ImpactDetails <chr> "Each year, in England alone, approximately 152,...

If you are confused by the use of the `%<>%` operator then you should call `?'%<>%'` to learn more about it!

Tidy Text
---------

The basic unit of analysis in this project is the sentence, so we will need to break down the text into sentences for later analysis. We can do this using the `tidytext` package.

``` r
tidy_ref <- unnest_tokens(ref, Sentence, ImpactDetails, "sentences", to_lower=F)
glimpse(tidy_ref)
```

    ## Observations: 210,972
    ## Variables: 6
    ## $ CaseStudyId <chr> "100", "100", "100", "100", "100", "100", "100", "...
    ## $ UOA         <chr> "Architecture, Built Environment and Planning", "A...
    ## $ ImpactType  <chr> "Cultural", "Cultural", "Cultural", "Cultural", "C...
    ## $ Institution <chr> "Nottingham Trent University", "Nottingham Trent U...
    ## $ Title       <chr> "Managing heritage, designing futures: heritage do...
    ## $ Sentence    <chr> "The historical, cultural, methodological and ethi...

Fit a GloVe Model
-----------------

``` r
source("Functions/fit_glove_model.R")
tmp <- fit_glove_model(ref$ImpactDetails, 100, 15) # From Tuning.md
glove <- tmp[[1]]
vocab <- tmp[[2]]
rm(tmp)
word_vectors <- glove$get_word_vectors()
```

Locate Sentences in GloVe Representation
----------------------------------------

The rows of this matrix will align with the rows of the `tidy_ref` data frame, so neither object should be sorted permanently. We will be applying a tfidf transform (and we will need to reapply this transform later) so the tfidf model object is fit to the data prior to being passed into the function.

``` r
source("Functions/fit_tfidf.R")
tfidf <- fit_tfidf(tidy_ref$Sentence, vocab)
source("Functions/get_sentence_vectors.R")
sentence_vectors <- get_sentence_vectors(sentences = tidy_ref$Sentence, 
                                         vocab = vocab, 
                                         transform = tfidf, 
                                         wv = word_vectors)
```

Import Unseen Data and Identify Outliers
----------------------------------------

Ten impact case studies were kept out of the training data to allow testing on unseen data. Each of these 10 case studies will have a new sentence added to the ImpactDetails field, and these sentences will be intentionally unsuitable for inclusion in an impact case study.

``` r
source("Functions/add_bad_sentences.R")
test <- add_bad_sentences(test)
```

Ordinarily these unseen documents would be analysed individually, however for the purposes of demonstration we will consider all 10 documents at once. To do this we need to clean up the text by removing whitespace, and then break the documents down into individual sentences.

``` r
test$Institution %<>%   str_replace_all("\\s+", " ") %>% 
                       str_replace_all("(^\\s+)|(\\s+$)", "")
test$Title %<>%         str_replace_all("\\s+", " ") %>% 
                       str_replace_all("(^\\s+)|(\\s+$)", "")
test$ImpactDetails %<>% str_replace_all("\\s+", " ") %>% 
                       str_replace_all("(^\\s+)|(\\s+$)", "")
tidy_test <- unnest_tokens(test, Sentence, ImpactDetails, "sentences", to_lower=F)
```

We can now calculate the vector representation of each of these unseen sentences using the pre-discovered vocabulary, the pre-trained GloVe model and the pre-trained tfidf transformation.

``` r
unseen_vectors <- get_sentence_vectors(sentences = tidy_test$Sentence, 
                                         vocab = vocab, 
                                         transform = tfidf, 
                                         wv = word_vectors)
```

We can now try and find those 10 "bad" sentences automatically using euclidean distances in the GloVe model space.

### Average Sentence Approach

This approach calculates the distance from each sentence to the "average sentence" from the training corpus. The average sentence is quite close to zero, so this could also be achieved by calculating each sentence vector length in the GloVe vector space.

``` r
average_sentence <- colMeans(as.matrix(sentence_vectors))
tidy_test$global_distance <- 
  dist2(x = as.matrix(unseen_vectors), y = t(as.matrix(average_sentence)), 
       method = "euclidean", norm = "l2")[,1]
tidy_test %>% arrange(desc(global_distance)) %>%
  select(Sentence) %>%
  head(10)
```

    ## # A tibble: 10 × 1
    ##                                                                       Sentence
    ##                                                                          <chr>
    ## 1                                                     Autoimmune encephalitis.
    ## 2  For instance, when discussing dosing and augmentation of clozapine, use of 
    ## 3  For example, Taylor 2009a is used throughout when considering clozapine aug
    ## 4  "The differential diagnosis of acute encephalitis is broad, encompassing in
    ## 5  Torture Team research successfully challenged the narrative of the US admin
    ## 6  This was in consequence of a conviction that gender bias (as well as other 
    ## 7  In 2011 Human Rights Watch, an international non-governmental organization,
    ## 8  The actor who played Burton in the BBC4 biopic, `immersed himself in Richar
    ## 9  The two standard treatments for myasthenia gravis are anticholinesterase dr
    ## 10 Commemorating Burton Initiatives to commemorate and celebrate Burton's care

This approach is not working well - the "bad" sentences don't start showing up until row 20 (out of 302). We can do better!

### Average Distance Approach

Instead of calculating the distance from the average, we can calculate the average distance from the other sentences.

``` r
distances <- 
  dist2(x = as.matrix(unseen_vectors), y = as.matrix(sentence_vectors), 
       method = "euclidean", norm = "l2")
tidy_test$average_distance <- rowMeans(distances)
rm(distances)
tidy_test %>% arrange(desc(average_distance)) %>%
  select(Sentence) %>%
  head(10)
```

    ## # A tibble: 10 × 1
    ##                                                                       Sentence
    ##                                                                          <chr>
    ## 1  For instance, when discussing dosing and augmentation of clozapine, use of 
    ## 2                                                     Autoimmune encephalitis.
    ## 3  For example, Taylor 2009a is used throughout when considering clozapine aug
    ## 4  Torture Team research successfully challenged the narrative of the US admin
    ## 5  "The differential diagnosis of acute encephalitis is broad, encompassing in
    ## 6  This was in consequence of a conviction that gender bias (as well as other 
    ## 7  In 2011 Human Rights Watch, an international non-governmental organization,
    ## 8  Commemorating Burton Initiatives to commemorate and celebrate Burton's care
    ## 9  The actor who played Burton in the BBC4 biopic, `immersed himself in Richar
    ## 10 The two standard treatments for myasthenia gravis are anticholinesterase dr

This is also not ideal, the first "bad" sentence showed up in position 14, but we must be able to do better!

### Word Mover's Distance

This is a long shot, and it's a very expensive computation, but it has worked well for replacement so I have high hopes!

``` r
tokens <- 
  tidy_ref$Sentence %>% 
  str_to_lower() %>% 
  str_replace_all("[^[:alnum:]]", " ") %>% 
  str_replace_all("\\s+", " ") %>% 
  str_replace_all("(^\\s+)|(\\s+$)", "") %>% 
  word_tokenizer()
it <- itoken(tokens)
vectorizer <- vocab_vectorizer(vocab)
dtm <- create_dtm(it, vectorizer)

tokens <- 
  tidy_test$Sentence %>% 
  str_to_lower() %>% 
  str_replace_all("[^[:alnum:]]", " ") %>% 
  str_replace_all("\\s+", " ") %>% 
  str_replace_all("(^\\s+)|(\\s+$)", "") %>% 
  word_tokenizer()
it <- itoken(tokens)
vectorizer <- vocab_vectorizer(vocab)
unseen_dtm <- create_dtm(it, vectorizer)

rwmd <- RelaxedWordMoversDistance$new(word_vectors)
rwmd$verbose <- FALSE
rwmd_distance <- dist2(unseen_dtm, dtm, 
                       method = rwmd, 
                       norm = "none")
tidy_test$rwmd_distance <- rowMeans(rwmd_distance)
rm(rwmd_distance)
tidy_test %>% arrange(desc(rwmd_distance)) %>%
  select(Sentence) %>%
  head(10)
```

    ## # A tibble: 10 × 1
    ##                                                                       Sentence
    ##                                                                          <chr>
    ## 1                                                     Autoimmune encephalitis.
    ## 2                                                                        108].
    ## 3                                                                           i.
    ## 4                                                                    B, III)."
    ## 5  Autoimmune Disorders (VGKC-complex proteins, LGI1, CASPR2, contactin-2) PCT
    ## 6                                                                           6.
    ## 7                                                                           4.
    ## 8                                                                           2.
    ## 9                                                                           3.
    ## 10                                                                          5.

This isn't working so well either! Let's plot some distributions and see if we're getting anything useful from these metrics at all...

``` r
tidy_test$quality <- "Good"
# Get the final sentence in each case study and label it as "Bad"
case_studies <- unique(tidy_test$CaseStudyId)
rows <- c(1:10) # Dummy values
for (i in 1:10) {
  rows[i] <- max(which(tidy_test$CaseStudyId == case_studies[i]))
}
tidy_test$quality[rows] <- "Bad"
rm(rows)
# Plot some distributions
ggplot(tidy_test) + 
  geom_density(aes(x=global_distance, fill=quality), alpha=0.7)
```

![](Implementation_files/figure-markdown_github/unnamed-chunk-1-1.png)

``` r
ggplot(tidy_test) + 
  geom_density(aes(x=average_distance, fill=quality), alpha=0.7)
```

![](Implementation_files/figure-markdown_github/unnamed-chunk-1-2.png)

``` r
ggplot(tidy_test) + 
  geom_density(aes(x=rwmd_distance, fill=quality), alpha=0.7)
```

![](Implementation_files/figure-markdown_github/unnamed-chunk-1-3.png)

These metrics are definitely useful, but they aren't perfect.

Sentence Replacement Suggestions
--------------------------------

The next key component is the suggestion of replacement sentences. For the development of this component I will be using the "known bad" sentences, i.e. the sentences which I used to vandalise the otherwise well-written impact case studies.

``` r
replacement_candidates <- tidy_test$Sentence[tidy_test$quality == "Bad"]
```

We will use the Relaxed Word Mover's Distance exclusively for this part of the project given how well it worked in the experimentation phase.

``` r
for (i in seq_along(replacement_candidates)) {
  message("Sentence to be replaced is:")
  cat(replacement_candidates[i])
  
  tokens <- 
    replacement_candidates[i] %>% 
    str_to_lower() %>% 
    str_replace_all("[^[:alnum:]]", " ") %>% 
    str_replace_all("\\s+", " ") %>% 
    str_replace_all("(^\\s+)|(\\s+$)", "") %>% 
    word_tokenizer()
  it <- itoken(tokens)
  vectorizer <- vocab_vectorizer(vocab)
  unseen_dtm <- create_dtm(it, vectorizer)

  rwmd <- RelaxedWordMoversDistance$new(word_vectors)
  rwmd$verbose <- FALSE
  tidy_ref$rwmd_distance <- dist2(dtm, unseen_dtm, 
                                  method = rwmd, 
                                  norm = "none")[,1]
  suggestions <- tidy_ref %>% 
    arrange(rwmd_distance) %>% 
    head(3)
  
  message("Try and make your sentence more like one of these:")
  print(suggestions$Sentence)
}
```

    ## Sentence to be replaced is:

    ## We had a really big team and everyone did something different.

    ## Try and make your sentence more like one of these:

    ## [1] "We will be adding a knowledge quiz and Did You Know?"                                                  
    ## [2] "They all felt it was very relevant and really was something they could connect with."                  
    ## [3] "For some of those patients who we had not planned to operate, we have then taken a different approach."

    ## Sentence to be replaced is:

    ## My analysis was awesome and had a huge impact on the world.

    ## Try and make your sentence more like one of these:

    ## [1] "The wider impact of this research has been acknowledged within the museum world both in the UK and abroad: `the project had a transformatory effect on the V&amp;A."   
    ## [2] "Impact on Policy The research associated with the development and evaluation of ASSIST has had a substantial impact on policy."                                        
    ## [3] "In addition to the impact on public policy and its resultant impact on health and wellbeing, this work has had a significant impact on both society and practitioners."

    ## Sentence to be replaced is:

    ## The University of Technology Sydney is the best university in the world.

    ## Try and make your sentence more like one of these:

    ## [1] "This technology is the first and the only one available in the world."
    ## [2] "The MIT museum is one of the largest Holography Museums in the world."
    ## [3] "This is the first service of its kind anywhere in the world."

    ## Sentence to be replaced is:

    ## Every year lots of people are sick with a sleep disease.

    ## Try and make your sentence more like one of these:

    ## [1] "Every year around 17,000 people in the USA and 2,400 in the UK are diagnosed with the disease."                         
    ## [2] "800 people develop CML each year in the UK and there are currently over 6,000 patients with the disease."               
    ## [3] "An estimated 62,000 people develop the disease each year, of which the majority are in the early stages of the disease."

    ## Sentence to be replaced is:

    ## Many of our patients said that they felt better.

    ## Try and make your sentence more like one of these:

    ## [1] "Research into that is helping treatment of it and our understanding of how it works.\""
    ## [2] "This means that more patients are free of their disease."                              
    ## [3] "And in aspects of our practice they had an influence.\""

    ## Sentence to be replaced is:

    ## We got our project in the local newspaper and on television.

    ## Try and make your sentence more like one of these:

    ## [1] "The conference on the Frisian tablet also generated local and national newspaper and television reports."                                                               
    ## [2] "It has also been disseminated in local, national and international broadcasts and through the publication of articles in local and national newspapers."                
    ## [3] "The project, and the successful launch of the boat in April 2013, were reported by the BBC and ITV in extended reports on national and local television and radio (e.g."

    ## Sentence to be replaced is:

    ## A lot of people used to die and now less people die.

    ## Try and make your sentence more like one of these:

    ## [1] "The Care People: The Care People is a social enterprise established to provide care to children and older people."
    ## [2] "The impacts affect the life chances of many young (and less young) people."                                       
    ## [3] "This has changed and this change of perceptions is down to the work of people such as Ailsa\"."

    ## Sentence to be replaced is:

    ## We came up with a new way of doing things that was better than the old way.

    ## Try and make your sentence more like one of these:

    ## [1] "In doing so, it has informed individuals by equipping them with a better understanding of the nature of the Templars."                           
    ## [2] "For a fund that was less than one year old at the time, this demonstrates the quality of its proposition [7]."                                   
    ## [3] "As a result the new galleries adopted a chronological approach that opens `up the history of making and using objects in a way that reflects ..."

    ## Sentence to be replaced is:

    ## We worked with people from the biology, psychology and computer science departments.

    ## Try and make your sentence more like one of these:

    ## [1] "Specifically, the collaboration examined the impact of our brain-computer research on public perceptions and engagement with science and society."                                     
    ## [2] "We have worked with the Science Media Centre in educating journalists about our work."                                                                                                 
    ## [3] "Wildlife groups and other local agencies will be able to continue to apply and extend the expertise they have developed from engagement with the project and its underpinning science."

    ## Sentence to be replaced is:

    ## Other universities really liked what we did and now they want to do it too.

    ## Try and make your sentence more like one of these:

    ## [1] "It is really what the Japanese are like and not just what Westerners think they are like.\"["
    ## [2] "It is really what the Japanese are like and not just what Westerners think they are like'."  
    ## [3] "We helped answer questions such as: if communities are to do more, how do they go about it?"
