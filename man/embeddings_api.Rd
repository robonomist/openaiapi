% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/embeddings.R
\name{embeddings_api}
\alias{embeddings_api}
\alias{oai_create_embeddings}
\title{Embeddings API}
\usage{
oai_create_embeddings(
  input,
  model,
  encoding_format = c("float", "base64"),
  dimensions = NULL,
  user = NULL,
  .classify_response = TRUE,
  .async = FALSE
)
}
\arguments{
\item{input}{Character. Input text to embed, encoded as a string or array of tokens. To embed multiple inputs in a single request, pass an array of strings or array of token arrays. The input must not exceed the max input tokens for the model (8192 tokens for text-embedding-ada-002), cannot be an empty string, and any array must be 2048 dimensions or less. Example Python code for counting tokens.}

\item{model}{Character. ID of the model to use. You can use the \code{oai_list_models()} function to see all of your available models.}

\item{encoding_format}{Character. Defaults to "float". The format to return the embeddings in. Can be either "float" or "base64".}

\item{dimensions}{Integer. The number of dimensions the resulting output embeddings should have. Only supported in text-embedding-3 and later models.}

\item{user}{Character. A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.}

\item{.classify_response}{Logical. If \code{TRUE} (default), the response is classified as an R6 object. If \code{FALSE}, the response is returned as a list.}

\item{.async}{Logical. If \code{TRUE}, the request is performed asynchronously.}
}
\value{
A list of Embedding R6 objects.
}
\description{
Get a vector representation of a given input that can be easily consumed by machine learning models and algorithms.

\itemize{
\item \code{oai_create_embeddings()}: Creates an embedding vector representing the input text.
}
}
