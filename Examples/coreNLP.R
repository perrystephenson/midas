# Exploring coreNLP package
library(coreNLP)

# To download the libraries when using for the first time, run:
# downloadCoreNLP()

initCoreNLP(mem="8g", type="english_all")
sIn <- "Mother died today. Or, maybe, yesterday; I can't be sure."
annoObj <- annotateString(sIn)

annoObj$token
annoObj$basicDep
annoObj$collapsedDep
annoObj$collapsedProcDep
annoObj$coref
annoObj$openie
annoObj$sentiment
