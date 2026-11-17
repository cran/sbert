## ----options, include = FALSE-----------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", fig.width = 7,
                      fig.height = 4.5, fig.align = "center", dpi = 96)
old_options <- options(digits = 3, width = 90)

## ----setup------------------------------------------------------------------------------
library(sbert)

## ----data-------------------------------------------------------------------------------
corpus <- head(dedupe(feedback_translations, column = "translation"), 600)
dim(feedback_embeddings)

## ----pool-input-------------------------------------------------------------------------
token_vectors <- array(1:12, dim = c(2, 3, 2))
mask <- matrix(c(1, 1, 0,
                 1, 1, 1), nrow = 2, byrow = TRUE)
pool(token_vectors, mask, normalize = FALSE)

## ----pool-methods-----------------------------------------------------------------------
pool(token_vectors, mask, normalize = FALSE, method = "cls")
pool(token_vectors, mask)

## ----norms------------------------------------------------------------------------------
summary(sqrt(rowSums(feedback_embeddings^2)))

## ----models-----------------------------------------------------------------------------
models()

## ----models-detail----------------------------------------------------------------------
subset(models(detail = TRUE), select = c(model, pooling, prefix, engine))

## ----cache-dir--------------------------------------------------------------------------
cache_dir()

## ----model-status-----------------------------------------------------------------------
status <- model_status()
subset(status, select = c(file, exists, valid, expected_bytes))

## ----setup-once, eval = FALSE-----------------------------------------------------------
# install_runtime()
# model_download("all-MiniLM-L6-v2")

## ----encode, eval = FALSE---------------------------------------------------------------
# embeddings <- with(corpus, encode(translation))
# 
# model <- load_model("all-MiniLM-L6-v2", threads = 4)
# embeddings <- with(corpus, encode(translation, model = model))

## ----first-four-------------------------------------------------------------------------
head(corpus, 4)

## ----similarity-------------------------------------------------------------------------
pairs <- topic_similarity(head(feedback_embeddings, 4), tidy = TRUE)
subset(pairs, from < to)

## ----neighbors--------------------------------------------------------------------------
query_text <- "There should be two more in the red than in the blue."
query <- subset(feedback_embeddings, with(corpus, translation == query_text))
neighbors <- transform(corpus,
                        similarity = topic_similarity(feedback_embeddings, query))
subset(neighbors, similarity > 0.8, select = c(translation, similarity))

## ----new-query, eval = FALSE------------------------------------------------------------
# query <- encode("Count the pictures in each box again.")
# neighbors <- transform(corpus,
#                         similarity = topic_similarity(feedback_embeddings, query))

## ----restore-options, include = FALSE-----------------------------------------
options(old_options)

