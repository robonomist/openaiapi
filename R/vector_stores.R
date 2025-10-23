#' Vector Store API
#'
#' Vector stores are used to store files for use by the `file_search` tool.
#'
#' @name vector_store_api
#' @inheritParams oai_create_assistant
#' @return VectorStore R6 object.
NULL

#' @description * `oai_create_vector_store()`: Create a new vector store.
#' @param file_ids Character. Optional. A vector of file IDs to include in the vector store.
#' @param name Character. Optional. A name for the vector store.
#' @param expires_after List. Optional. Expiration time for the vector store in seconds.
#' @param chunking_strategy List. Optional. Strategy for chunking data.
#' @rdname vector_store_api
#' @export
oai_create_vector_store <- function(file_ids = NULL,
                                    name = NULL,
                                    expires_after = NULL,
                                    chunking_strategy = NULL,
                                    metadata = NULL,
                                    .classify_response = TRUE,
                                    .async = FALSE) {
  body <- list(
    file_ids = as.list(file_ids),
    name = name,
    expires_after = expires_after,
    chunking_strategy = chunking_strategy,
    metadata = metadata
  )
  oai_query(
    ep = "vector_stores",
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_list_vector_stores()`: List vector stores.
#'
#' @return `oai_list_vector_stores()` returns a list of VectorStore objects.
#' @rdname vector_store_api
#' @export
oai_list_vector_stores <- function(limit = NULL,
                                   order = NULL,
                                   after = NULL,
                                   before = NULL,
                                   .classify_response = TRUE,
                                   .async = FALSE) {
  query <- as.list(environment())
  oai_query_list(
    ep = "vector_stores",
    headers = openai_beta_header(),
    method = "GET",
    query = query,
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_retrieve_vector_store()`: Retrieve a specific vector store.
#'
#' @param vector_store_id Character. The ID of the vector store to retrieve.
#' @rdname vector_store_api
#' @export
oai_retrieve_vector_store <- function(vector_store_id,
                                      .classify_response = TRUE,
                                      .async = FALSE) {
  oai_query(
    c("vector_stores", vector_store_id),
    headers = openai_beta_header(),
    method = "GET",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_modify_vector_store()`: Modify a specific vector store.
#'
#' @rdname vector_store_api
#' @export
oai_modify_vector_store <- function(vector_store_id,
                                    name = NULL,
                                    expires_after = NULL,
                                    metadata = NULL,
                                    .classify_response = TRUE,
                                    .async = FALSE) {
  body <- list(
    name = name,
    expires_after = expires_after,
    metadata = metadata
  )
  oai_query(
    c("vector_stores", vector_store_id),
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_delete_vector_store()`: Delete a specific vector store.
#'
#' @return Deletion status.
#' @rdname vector_store_api
#' @export
oai_delete_vector_store <- function(vector_store_id,
                                    .async = FALSE) {
  oai_query(
    c("vector_stores", vector_store_id),
    headers = openai_beta_header(),
    method = "DELETE",
    .async = .async
  )
}

#' @description * `oai_search_vector_store()`: Search a specific vector store.
#'
#' @param query Character. The query string for the search.
#' @param filters List. Optional. A filter to apply based on file attributes.
#' @param max_num_results Integer. Optional. The maximum number of results to return (1-50).
#' @param ranking_options List. Optional. Ranking options for the search.
#' @param rewrite_query Logical. Optional. Whether to rewrite the natural language query for vector search.
#' @rdname vector_store_api
#' @export
#' @return * `oai_search_vector_store()` returns a list of search results from the vector store.
oai_search_vector_store <- function(vector_store_id,
                                    query,
                                    filters = NULL,
                                    max_num_results = NULL,
                                    ranking_options = NULL,
                                    rewrite_query = NULL,
                                    .classify_response = TRUE,
                                    .async = FALSE) {
  body <- list(
    query = query,
    filters = filters,
    max_num_results = as.integer(max_num_results),
    ranking_options = ranking_options,
    rewrite_query = rewrite_query
  )
  oai_query(
    c("vector_stores", vector_store_id, "search"),
    body = body,
    method = "POST",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' R6 class for managing a Vector Store in the OpenAI API
#'
#' The `VectorStore` class provides methods to manage vector stores.
#' @field id Character. The unique identifier of the vector store.
#' @field created_at POSIXct. The timestamp when the vector store was created.
#' @field name Character. The name of the vector store.
#' @field usage_bytes Numeric. The total number of bytes used by the vector store.
#' @field file_counts Integer. The number of files in the vector store.
#' @field status Character. The current status of the vector store.
#' @field expires_after List. The duration after which the vector store will expire.
#' @field expires_at POSIXct. The exact timestamp when the vector store will expire.
#' @field last_active_at POSIXct. The last time the vector store was active.
#' @field metadata List. Additional metadata associated with the vector store.
#' @param vector_store_id Character. Optional. The ID of the vector store to initialize.
#' @param file_ids Character. Optional. A vector of file IDs to include in the vector store.
#' @param file_id Character. The ID of the file to be added to the vector store.
#' @param path Character. The path to the file to upload.
#' @param batch_id Character. The ID of the batch to retrieve.
#' @param ... Additional arguments to be passed to the API functions.
#' @importFrom R6 R6Class
#' @export
VectorStore <- R6Class(
  "VectorStore",
  portable = FALSE,
  inherit = Utils,
  private = list(
    schema = list(
      as_is = c("expires_after", "file_counts", "id", "metadata", "name",
                "status", "usage_bytes"),
      as_time = c("created_at", "expires_at", "last_active_at")
    )
  ),
  public = list(
    #' @description Initialize a VectorStore object
    #'
    #' @param resp A list. The response object from the OpenAI API containing details of the vector store.
    #' @return A new instance of a VectorStore object.
    initialize = function(vector_store_id = NULL, ..., resp = NULL) {
      if (!is.null(resp)) {
        store_response(resp)
      } else if (!is.null(vector_store_id)) {
        oai_retrieve_vector_store(
          vector_store_id = vector_store_id,
          .classify_response = FALSE
        ) |>
          store_response()
      } else {
        oai_create_vector_store(..., .classify_response = FALSE) |>
          store_response()
      }
    },
    id = NULL,
    created_at = NULL,
    name = NULL,
    usage_bytes = NULL,
    file_counts = NULL,
    status = NULL,
    expires_after = NULL,
    expires_at = NULL,
    last_active_at = NULL,
    metadata = NULL,
    #' @description Retrieve the vector store
    #'
    #' @return The updated VectorStore object after retrieving its details from the OpenAI API.
    retrieve = function() {
      oai_retrieve_vector_store(
        vector_store_id = self$id,
        .classify_response = FALSE,
        .async = .async
      ) |>
        store_response()
    },
    #' @description Modify the vector store. The `...` argument is passed to `oai_modify_vector_store()`.
    modify = function(...) {
      args <- list(
        ..., vector_store_id = self$id, .classify_response = FALSE, .async = .async
      )
      do.call(oai_modify_vector_store, args) |>
        store_response()
    },
    #' @description Delete the vector store.
    delete = function() {
      oai_delete_vector_store(vector_store_id = self$id, .async = .async)
    },
    #' @description
    #' Create a file in the vector store. The `...` argument is passed to `oai_create_vector_store_file()`.
    create_file = function(file_id, ...) {
      if (inherits(file_id, "File")) {
        file_id <- file_id$id
      }
      oai_create_vector_store_file(
        vector_store_id = self$id, file_id = file_id, ...,
        .async = .async
      )
    },
    #' @description
    #' Upload a file to the vector store. The `...` argument is passed to `oai_upload_file()`.
    upload_file = function(path, ...) {
      if (length(path) == 1L) {
        file_id <- oai_upload_file(path, purpose, ...)$id
        self$create_file(file_id, ...)
      } else if (length(path) > 1L) {
        cli_alert_info("Creating a file batch...")
        file_ids <-
          lapply(path, function(x) oai_upload_file(x, ...)$id) |>
          unlist(use.names = FALSE)
        self$create_file_batch(file_ids, ...)
      }
    },
    #' @description List files in the vector store. The `...` argument is passed to `oai_list_vector_store_files()`.
    list_files = function(...) {
      args <- list(vector_store_id = self$id, ..., .async = .async)
      do.call(oai_list_vector_store_files, args)
    },
    #' @description Retrieve a file in the vector store.
    retrieve_file = function(file_id) {
      oai_retrieve_vector_store_file(
        vector_store_id = self$id,
        file_id = file_id,
        .async = .async
      )
    },
    #' @description Delete a file in the vector store.
    delete_file = function(file_id) {
      oai_delete_vector_store_file(vector_store_id = self$id, file_id = file_id, .async = .async)
    },
    #' @description Search the vector store.
    #' @param query Character. The query string for the search.
    #' @param filters List. Optional. A filter to apply based on file attributes.
    search = function(query, ...) {
      oai_search_vector_store(
        vector_store_id = self$id,
        query = query,
        ...,
        .async = .async
      )
    },
    #' @description Create a file batch. The `...` argument is passed to `oai_create_vector_store_file_batch()`.
    #' @return A VectorStoreFilesBatch R6 object.
    create_file_batch = function(file_ids, ...) {
      oai_create_vector_store_file_batch(
        vector_store_id = self$id, file_ids = file_ids, ...
      )
    },
    #' @description Retrieve a file batch.
    retrieve_file_batch = function(batch_id) {
      oai_retrieve_vector_store_file_batch(
        vector_store_id = self$id,
        batch_id = batch_id,
        .async = .async
      )
    },
    #' @description Cancel a file batch
    cancel_file_batch = function(batch_id) {
      oai_cancel_vector_store_file_batch(
        vector_store_id = self$id,
        batch_id = batch_id,
        .async = .async
      )
    },
    #' @description List files in a batch
    list_files_in_a_batch = function(batch_id = batch_id, ...) {
      args <- list(vector_store_id = self$id, batch_id = batch_id, ..., .async = .async)
      do.call(oai_list_vector_store_files_in_a_batch, args)
    },
    #' @description
    #' Print the VectorStore object
    #' @param ... Unused.
    print = function(...) {
      .print(
        "id" = self$id,
        "name" = self$name,
        "created_at" = format(self$created_at),
        "usage_bytes" = self$usage_bytes,
        "status" = self$status
      )
    }
  )
)
