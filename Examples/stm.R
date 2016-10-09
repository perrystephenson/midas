# Structural Topic Modelling

library(stm)

data <- read.csv("~/poliblogs2008.csv")
processed <- textProcessor(data$documents, metadata = data)
out <- prepDocuments(processed$documents, processed$vocab, processed$meta)
docs <- out$documents
vocab <- out$vocab
meta <-out$meta

poliblogPrevFit <- stm(out$documents, out$vocab, K = 20,
                       prevalence =~ rating + s(day), max.em.its = 75,
                       data = out$meta, init.type = "Spectral")

# That was REALLY SLOW!


poliblogSelect <- selectModel(out$documents, out$vocab, K = 20,
                              prevalence =~ rating + s(day), max.em.its = 75,
                              data = out$meta, runs = 20, seed = 8458159)

# Had to cancel - was taking hours.

selectedmodel <- poliblogSelect$runout[[3]]

storage <- searchK(out$documents, out$vocab, K = c(7, 10),
                   prevalence =~ rating + s(day), data = meta)

plotModels(poliblogSelect)

# This is just too slow to use. Might be worth a look when someone implements it
# in a compiled language.