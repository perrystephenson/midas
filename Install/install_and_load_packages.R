# This script checks whether a package can be loaded, and either:
# 1. loads it, or
# 2. installs it and then loads it
# Failure to load will result in an error.

# text2vec
if(!require(text2vec)) {
  install.packages("text2vec")
  library(text2vec)
}

# tidytext
if(!require(tidytext)) {
  install.packages("tidytext")
  library(tidytext)
}

# NLP
if(!require(NLP)) {
  install.packages("NLP")
  library(NLP)
}

# coreNLP
if(!require(coreNLP)) {
  install.packages("coreNLP")
  library(coreNLP)
}

# caret
if(!require(caret)) {
  install.packages("caret")
  library(caret)
}

# glmnet
if(!require(glmnet)) {
  install.packages("glmnet")
  library(glmnet)
}

# stm
if(!require(stm)) {
  install.packages("stm")
  library(stm)
}
