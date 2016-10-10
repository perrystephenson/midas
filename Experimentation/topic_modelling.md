UK REF Impact Case Studies - Topic Modelling
================

*This script explores the UK REF Impact Case Studies dataset. The dataset was previously extracted from <http://impact.ref.ac.uk/CaseStudies/> using the refimpact package (which was developed as part of this iLab project) and saved locally to allow for faster access.*

Preparation
-----------

``` r
library(text2vec)
library(stringr)
```

Data Preparation
----------------

Firstly we will load the data into memory and clean it up a little, then create a Document Term Matrix

``` r
ref <- readRDS("~/ref_data.rds")
prepare_text <- function(x) {
  x %>% 
  str_to_lower %>% 
  str_replace_all("[^[:alnum:]]", " ") %>% 
  str_replace_all("\\s+", " ")
}
ref$ImpactDetails <- prepare_text(ref$ImpactDetails)
it <- itoken(ref$ImpactDetails)
v <- create_vocabulary(it) %>% 
  prune_vocabulary(doc_proportion_max = 0.1, term_count_min = 5)
vectorizer <- vocab_vectorizer(v)
dtm <- create_dtm(it, vectorizer)
```

Now we will apply the TF-IDF transformation and fit a Latent Semantic Analysis topic model. Given that there are 36 units of assessment, let's try fitting a model with 36 topics.

``` r
tfidf <- TfIdf$new()
lsa <- LSA$new(n_topics = 36)
dtm_tfidf_lsa <- dtm %>% 
  fit_transform(tfidf) %>% 
  fit_transform(lsa)
head(dtm_tfidf_lsa)
```

    ##         [,1]          [,2]          [,3]         [,4]         [,5]
    ## 1 0.08697976 -0.3733921455 -0.0589141437  0.036482896 -0.017315453
    ## 2 0.04447787 -0.0001622475  0.0032507227 -0.016998987 -0.003889740
    ## 3 0.04297915 -0.0024689871  0.0019603082 -0.020472154 -0.006988385
    ## 4 0.03885454  0.0001453546  0.0009413536 -0.031006891 -0.022168839
    ## 5 0.04210576 -0.0018166452  0.0030165130 -0.009007014 -0.017857501
    ## 6 0.04358125 -0.0080684047  0.0014141950 -0.031003003 -0.004780796
    ##           [,6]          [,7]         [,8]         [,9]         [,10]
    ## 1  0.007890217 -0.0051495518 -0.001296653  0.006177043  0.0011918481
    ## 2 -0.011491374  0.0072400556 -0.004412126 -0.012441329 -0.0005277973
    ## 3 -0.017612151 -0.0086230801 -0.019296672 -0.012715219 -0.0115309332
    ## 4 -0.011749599 -0.0164160638 -0.021131657 -0.023119033 -0.0157515482
    ## 5 -0.020800615  0.0008376805 -0.001653256 -0.003408034  0.0034424031
    ## 6 -0.018104460  0.0027876554 -0.014458847 -0.006932898 -0.0064302514
    ##          [,11]         [,12]        [,13]        [,14]       [,15]
    ## 1  0.007829082  1.541250e-03 -0.005354600 -0.002854414 0.007122053
    ## 2 -0.001595657  3.018062e-03  0.004660858 -0.004909247 0.006947160
    ## 3 -0.005891334  1.287017e-03  0.003385107 -0.007784458 0.006154536
    ## 4 -0.007669624 -3.960544e-05  0.007792684 -0.004562047 0.009991595
    ## 5 -0.007526390  3.559219e-03  0.005812251 -0.020167401 0.029752762
    ## 6 -0.009457665  5.234198e-04  0.003312712 -0.005515824 0.006599819
    ##         [,16]        [,17]        [,18]       [,19]        [,20]
    ## 1 -0.01172144 -0.002980887 0.0017851022 0.014238287  0.008791096
    ## 2 -0.01297343  0.004488017 0.0001240478 0.011694656  0.003255675
    ## 3 -0.01404686  0.000711414 0.0049638203 0.020103379  0.007012638
    ## 4 -0.01368197  0.008107347 0.0091686930 0.032288669 -0.013638067
    ## 5  0.01086345  0.015906287 0.0070621352 0.009293865 -0.001954868
    ## 6 -0.00739919 -0.001025524 0.0031326206 0.011108457 -0.001150824
    ##           [,21]         [,22]        [,23]        [,24]        [,25]
    ## 1 -0.0073675718 -0.0000797622 -0.001323761 -0.002327225 -0.000867046
    ## 2  0.0004794049 -0.0005874487 -0.022447760  0.011156047  0.012185436
    ## 3 -0.0044933654 -0.0007860596  0.006713479 -0.018147020 -0.023432513
    ## 4 -0.0052104286  0.0108256001  0.016985905  0.001756780  0.008827003
    ## 5 -0.0052753670  0.0125928043 -0.053157434  0.004218666  0.052444680
    ## 6 -0.0007445701 -0.0010699560  0.003541757 -0.013430883 -0.007120331
    ##          [,26]       [,27]        [,28]        [,29]        [,30]
    ## 1 -0.012128612 -0.02323550  0.007369205 -0.003103531  0.004227172
    ## 2 -0.004813462 -0.02919254  0.008868787  0.014386311  0.002401579
    ## 3 -0.033716512 -0.01617336  0.012255237 -0.006234488  0.013105903
    ## 4  0.015239825 -0.00254598 -0.001298104 -0.008661528 -0.004865932
    ## 5  0.017912823 -0.03671239  0.031063569 -0.025442755 -0.015399387
    ## 6 -0.020583578 -0.01149807  0.007370357  0.001622404 -0.004363096
    ##          [,31]       [,32]         [,33]        [,34]        [,35]
    ## 1  0.014568512 0.003131160 -0.0102138766  0.015332737 -0.006055663
    ## 2 -0.002408086 0.013224970  0.0143897112  0.021512141 -0.034828892
    ## 3  0.023028222 0.026144317 -0.0006556266 -0.016676728 -0.033512250
    ## 4 -0.015169439 0.002728744  0.0038823229  0.005322384 -0.004678740
    ## 5  0.006022870 0.017147342 -0.0130813960 -0.008296484 -0.030287232
    ## 6  0.014259944 0.012255016  0.0014253503  0.004371019 -0.013356430
    ##          [,36]
    ## 1  0.018780396
    ## 2  0.023421849
    ## 3  0.008170897
    ## 4 -0.004846676
    ## 5  0.018185832
    ## 6  0.010918268

That was quick! We could stop and visualise here, but text2vec includes a quick visualisation method for Latent Dirichtlet Analysis (which should be a more useful model anyway) so we might as well just skip to that.

``` r
tokens <- ref$ImpactDetails %>% 
  prepare_text() %>% 
  word_tokenizer
it <- itoken(tokens, ids = ref$CaseStudyId)
v <- create_vocabulary(it) %>% 
  prune_vocabulary(term_count_min = 10, doc_proportion_max = 0.2)
vectorizer <- vocab_vectorizer(v)
dtm <- create_dtm(it, vectorizer, type = "lda_c")

lda_model <- LDA$new(n_topics = 36, 
                     vocabulary = v, 
                     doc_topic_prior = 0.1, 
                     topic_word_prior = 0.01)
doc_topic_distr <- lda_model$fit_transform(dtm, 
                                           n_iter = 1000, 
                                           convergence_tol = 0.01, 
                                           check_convergence_every_n = 10)
```

    ## Early stopping on 140 iteradion. Perplexity improvement for last iteration was 0.97%

``` r
lda_model$plot()
```

    ## Loading required namespace: servr
