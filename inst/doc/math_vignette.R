## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  message = FALSE,
  warning = FALSE,
  fig.width = 7,
  fig.height = 4.5,
  dpi = 110,
  out.width = "100%"
)
library(sbert)

## ----menu---------------------------------------------------------------------
models()

## ----dedupe-------------------------------------------------------------------
corpus <- head(dedupe(feedback_translations$translation), 600)

## ----download, eval=FALSE-----------------------------------------------------
# model_download()

## ----sweep-show, eval=FALSE---------------------------------------------------
# sweep <- compare_topics(
#   corpus$text,
#   n_topics = c(4, 5, 6, 7, 8, 10, 12),
#   measure = "npmi",
#   n_representatives = 5
# )
# sweep

## ----sweep, include=FALSE-----------------------------------------------------
# The same 600 messages' embeddings ship precomputed with the package
# (data-raw/feedback_embeddings.R), so the sweep needs no download to build this
# vignette; feeding them in is identical to encoding live.
.sample <- readRDS(
  system.file("extdata", "feedback_embeddings.rds", package = "sbert")
)
stopifnot(identical(corpus$text, .sample$text))
sweep <- compare_topics(
  corpus$text,
  n_topics = c(4, 5, 6, 7, 8, 10, 12),
  embeddings = .sample$embeddings,
  measure = "npmi",
  n_representatives = 5
)

## ----sweep-print, echo=FALSE--------------------------------------------------
sweep

## ----sweep-plot, fig.height=4-------------------------------------------------
plot(sweep)

## ----model--------------------------------------------------------------------
topic_model <- fitted(sweep, n_topics = 6)

## ----model-print--------------------------------------------------------------
topic_model

## ----evaluate-----------------------------------------------------------------
summary(topic_model)

## ----coherence----------------------------------------------------------------
coherence(topic_model, measure = "npmi")

## ----sizes, fig.height=5------------------------------------------------------
plot(topic_model, type = "sizes")

## ----weighted-----------------------------------------------------------------
topic_sizes(topic_model, weights = corpus$n)

## ----beta---------------------------------------------------------------------
head(terms(topic_model, n = 8, sort_by = "beta"), 8)

## ----terms--------------------------------------------------------------------
head(terms(topic_model, n = 8), 8)

## ----plot-terms, fig.height=6-------------------------------------------------
plot(topic_model, type = "terms")

## ----plot-fit, fig.width = 8, fig.height = 11---------------------------------
plot(topic_model, type = "fit", n_terms = 8, n_representatives = 3)

## ----plot-fit-single, fig.height=4.5------------------------------------------
plot(topic_model, type = "fit", per_topic = TRUE, topics = 1)

## ----representatives----------------------------------------------------------
representatives(topic_model, n = 2)

## ----segments, eval=FALSE-----------------------------------------------------
# comparison <- compare_topics(
#   corpus$text,
#   n_topics = c(4, 6, 8),
#   segment = c("document", "sentence")
# )
# plot(comparison)
# plot(comparison, type = "fit", n_topics = 6, n_terms = 8, n_representatives = 3)
# 
# sentence_model <- fitted(comparison, n_topics = 6, segment = "sentence")
# topic_gamma(sentence_model)
# topic_sizes(sentence_model, by = "document", weights = corpus$n)

