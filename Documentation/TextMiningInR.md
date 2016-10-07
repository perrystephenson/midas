# Text Mining in R

With all of my new knowledge about text mining, it is worth reviewing what is available for use today. It's all well and good knowing about the latest and greatest techniques from internationally recognised researchers, but they aren't very useful for my iLab unless they've been implemented. Even if they have been implemented, I don't have time to learn another language, so they really need to be available in R.

This document will cover the current state of text mining in R in 2016.

## Text Management

There are several R packages jostling for the title of the best overall text management package. The `tm` package is the most popular with a clear lead over all of the other packages, and it enjoys the most support from other package authors - this means that most of the educational material is focused on the `tm` package. There are significantly better packages available, however there is no single package that can do everything.

| Capability                     | tm    | tidytext | qdap  | text2vec |
|--------------------------------|:-----:|:--------:|:-----:|:--------:|
| Tokenisation                   | **Y** | **Y**    | **Y** | **Y**    |  
| Stemming                       | **Y** | **Y**    | **Y** | **Y**    |  
| Stop-words                     | **Y** | **Y**    | **Y** | **Y**    |  
| N-grams                        |   -   | **Y**    | **Y** | **Y**    |  
| Skip-grams                     |   -   | **Y**    |   -   | **Y**    |  
| Sentiment tagging (pre-trained)|   -   | **Y**    | **Y** |   -      |  
| Advanced feature annotation    |   -   |   -      |   -   | **Y**    |  
| Basic visualisation            |   -   | **Y**    | **Y** |   -      |  
| Advanced visualisation         |   -   | **Y**    | **Y** | **Y**    |  
| Parallelisation                |   -   |   -      |   -   | **Y**    |  

Like with most things in R, the choice of package ends up being largely based on personal preference. However, if you want to analyse more than a few megabytes of data, then the `text2vec` package is definitely the way to go. It is without peer when it comes to speed on large datasets as it is carefully written for efficiency in C++. It also implements several other algorithms including LSA, LDA and GloVe (a word association algorithm). The author of the package has huge plans for this package and I suspect it will become the go-to package for text mining in R.

## Text Mining

There are lots of text mining tasks that you might want to perform in R, and knowing which of those tasks are available in which packages can be quite confusing. For the purposes of this table I will be listing my preferences for each of the tasks below, based on the following key criteria:

1. Ability to scale to big datasets (millions of rows), specifically
  * speed
  * memory footprint
2. Intuitive interface and interfaces with my preferred text management packages (`text2vec` and `tidytext`)

| Technique                       | Package  | Notes                      |
|---------------------------------|:--------:|:--------------------------:|
| Word Association                | text2vec | GloVe algorithm            |
| Latent Semantic Analysis (LSA)  | text2vec |                            |  
| Latent Dirichlet Analysis (LDA) | text2vec |                            |  
| Text Clustering                 | k-means  | (or hierarchical)          |  
| Text Categorisation             | caret    | (following vectorisation)  |  
| Sentiment Analysis              | coreNLP  | (via tidytext)             |  
| Opinion Mining                  | -        | -                          |  
| Latent Aspect Rating Analysis   | -        | -                          |  
| Contextual LSA                  | stm      | Structural Topic Modelling |  
| Network LSA                     | -        | -                          |  
| Time-Series LSA                 | -        | -                          |  

## Natural Language Processing

As mentioned several times in [Understanding Text Mining](./Documentation/UnderstandingTextMining.md), NLP is really hard. Most of it can't be done realiably and doesn't generalise well, and the stuff that can be done isn't necessarily accurate enough to be useful. There are some tools available however:

* The Stanford CoreNLP tools have been around long enough that there seems to be a reasonable wrapper in R (`coreNLP`).
* There is an Apache OpenNLP project, which is also available in R (`openNLP`).
* Google have released Parsey McParseface, a pre-trained SyntaxNet tagger built on top of their TensorFlow tool.

| Technique                       | R       | Other              |
|---------------------------------|---------|--------------------|
| Lexical Analysis (POS tagging)  | coreNLP | Parsey McParseface | 
| Syntactic Analysis (parsing)    | coreNLP | Parsey McParseface |  
| Semantic Analysis               | coreNLP | Parsey McParseface |  
| Inference                       |    -    |          -         |  
| Pragmatic Analysis (speech act) |    -    |          -         |  

Whilst SyntaxNet represents a significant technical improvement over CoreNLP, it does not appear to be enough of an improvement in accuracy to select it over CoreNLP, given that CoreNLP is easily available in R.


