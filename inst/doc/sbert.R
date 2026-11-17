## ----options, include = FALSE-----------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", fig.width = 7,
                      fig.height = 4.5, fig.align = "center", dpi = 96)
old_options <- options(digits = 3, width = 90)

## ----setup------------------------------------------------------------------------------
library(sbert)

## ----dedupe-----------------------------------------------------------------------------
messages <- dedupe(feedback_translations, column = "translation")
nrow(messages)
subset(messages, n >= 7, select = c(translation, n))

## ----corpus-----------------------------------------------------------------------------
corpus <- head(messages, 600)
dim(feedback_embeddings)
with(corpus, sum(n))

## ----live, eval = FALSE-----------------------------------------------------------------
# model_download()
# topic_model <- topics(corpus, n_topics = 6, column = "translation")

## ----sweep------------------------------------------------------------------------------
sweep <- compare_topics(corpus, column = "translation",
                        n_topics = c(4, 5, 6, 7, 8, 10, 12),
                        embeddings = feedback_embeddings)
sweep

## ----sweep-plot, fig.height = 4---------------------------------------------------------
plot(sweep)

## ----sweep-summary----------------------------------------------------------------------
summary(sweep)

## ----model------------------------------------------------------------------------------
topic_model <- fitted(sweep, n_topics = 6)
topic_model

## ----sizes------------------------------------------------------------------------------
topic_sizes(topic_model)

## ----name-topics------------------------------------------------------------------------
topic_model <- name_topics(topic_model, c(
  "Guiding question and instruction", "Short hint",
  "Question about meaning", "Correction", "Definition", "Negation"
))
topic_sizes(topic_model)

## ----representatives--------------------------------------------------------------------
knitr::kable(representatives(topic_model, n = 3, rank = "distance"),
             digits = 2)

## ----plot-representatives, fig.height = 4.5---------------------------------------------
plot(topic_model, type = "representatives", n_representatives = 3)

## ----weighted-sizes---------------------------------------------------------------------
topic_sizes(topic_model, weights = "n")

## ----plot-sizes, fig.height = 4---------------------------------------------------------
plot(topic_model, type = "sizes")

## ----terms------------------------------------------------------------------------------
terms(topic_model, n = 5)

## ----plot-terms, fig.height = 6---------------------------------------------------------
plot(topic_model, type = "terms")

## ----summary----------------------------------------------------------------------------
summary(topic_model)

## ----plot-fit, fig.width = 9, fig.height = 9--------------------------------------------
plot(topic_model, type = "fit", n_terms = 4, n_representatives = 3)

## ----restore-options, include = FALSE-----------------------------------------
options(old_options)

