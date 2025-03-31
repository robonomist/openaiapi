#' Embeddings API
#'
#' Get a vector representation of a given input that can be easily consumed by machine learning models and algorithms.
#' @inheritParams common_parameters
#' @return A list of Embedding R6 objects.
#' @name embeddings_api
NULL

#' @description * `oai_create_embeddings()`: Creates an embedding vector representing the input text.
#' @param input Character. Input text to embed, encoded as a string or array of tokens. To embed multiple inputs in a single request, pass an array of strings or array of token arrays. The input must not exceed the max input tokens for the model (8192 tokens for text-embedding-ada-002), cannot be an empty string, and any array must be 2048 dimensions or less. Example Python code for counting tokens.
#' @param model Character. ID of the model to use. You can use the `oai_list_models()` function to see all of your available models.
#' @param encoding_format Character. Defaults to "float". The format to return the embeddings in. Can be either "float" or "base64".
#' @param dimensions Integer. The number of dimensions the resulting output embeddings should have. Only supported in text-embedding-3 and later models.
#' @param user Character. A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
#' @inheritParams common_parameters
#' @export
#' @rdname embeddings_api
oai_create_embeddings <- function(input,
                                  model,
                                  encoding_format = c("float", "base64"),
                                  dimensions = NULL,
                                  user = NULL,
                                  .classify_response = TRUE,
                                  .async = FALSE
                                  ) {
  body <- list(
    input = input,
    model = model,
    encoding_format = match.arg(encoding_format),
    dimensions = dimensions,
    user = user
  )
  oai_query(
    ep = "embeddings",
    body = body,
    method = "POST",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' R6 class representing an Embedding in the OpenAI API
#' @export
Embedding <- R6Class(
  "Embedding",
  portable = FALSE,
  inherit = Utils,
  private = list(
    schema = list(
      as_is = "index",
      unlist = "embedding"
    )
  ),
  public = list(
    #' @description Initialize an Embedding object
    #' @param input Character. Input text to embed.
    #' @param model Character. ID of the model used to generate the embedding.
    #' @param resp A list. The response object from the OpenAI API containing details of the embedding.
    #' @param ... Additional arguments to be passed to the API functions.
    #' @param .async Logical. If TRUE, the function will return a promise.
    #' @return A new instance of an Embedding object.
    initialize = function(input, model, ...,
                          resp = NULL,
                          .async = FALSE) {
      if (!is.null(resp)) {
        store_response(resp)
      } else {
        oai_create_embeddings(input, model, ...,
                              .classify_response = FALSE,
                              .async = .async) |>
          store_response()
      }
    },
    #' @field embedding The embedding vector.
    embedding = NULL,
    #' @field index The index of the embedding in the list of embeddings.
    index = NULL,
    #' @description Print the Embedding object
    #' @param ... Unused.
    print = function(...) {
      .print("index" = self$index)
    }
  )
)
