#' Vector store file batch API
#'
#' Vector store file batches represent operations to add multiple files to a vector store.
#' @inheritParams oai_create_vector_store
#' @inheritParams oai_create_vector_store_file
#' @return A VectorStoreFilesBatch R6 object.
#' @name vector_store_file_batch_api
NULL

#' @description * `oai_create_vector_store_file_batch()`: Create a file batch in a vector store.
#'
#' @param vector_store_id Character. The ID of the vector store where the file batch will be created.
#' @param file_ids Character. A vector of file IDs to include in the batch.
#' @rdname vector_store_file_batch_api
#' @export
oai_create_vector_store_file_batch <- function(vector_store_id,
                                               file_ids,
                                               attributes = NULL,
                                               chunking_strategy = NULL,
                                               .classify_response = TRUE,
                                               .async = FALSE) {
  body <- list(
    file_ids = as.list(file_ids),
    attributes = attributes,
    chunking_strategy = chunking_strategy
  )
  oai_query(
    ep = c("vector_stores", vector_store_id, "file_batches"),
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_retrieve_vector_store_file_batch()`: Retrieve a specific file batch in a vector store.
#'
#' @param batch_id Character. The ID of the batch to retrieve.
#' @rdname vector_store_file_batch_api
#' @export
oai_retrieve_vector_store_file_batch <- function(vector_store_id,
                                                 batch_id,
                                                 .classify_response = TRUE,
                                                 .async = FALSE) {
  oai_query(
    ep = c("vector_stores", vector_store_id, "file_batches", batch_id),
    headers = openai_beta_header(),
    method = "GET",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_delete_vector_store_file_batch()`: Delete a specific file batch in a vector store.
#'
#' @rdname vector_store_file_batch_api
#' @export
oai_cancel_vector_store_file_batch <- function(vector_store_id,
                                               batch_id,
                                               .async = FALSE) {
  oai_query(
    ep = c("vector_stores", vector_store_id, "file_batches", batch_id, "cancel"),
    headers = openai_beta_header(),
    method = "POST",
    .async = .async
  )
}

#' @description * `oai_list_vector_store_files_in_a_batch()`: List all files in a file batch.
#'
#' @param filter Character. Optional. Filter the files based on certain criteria.
#' @inheritParams oai_list_vector_store_files
#' @return `oai_list_vector_store_files_in_a_batch()` returns a list of VectorStoreFile objects.
#' @rdname vector_store_file_batch_api
#' @export
oai_list_vector_store_files_in_a_batch <- function(vector_store_id,
                                                   batch_id,
                                                   limit = NULL,
                                                   order = NULL,
                                                   after = NULL,
                                                   before = NULL,
                                                   filter = NULL,
                                                   .classify_response = TRUE,
                                                   .async = FALSE) {
  query <- list(
    limit = as.integer(limit),
    order = order,
    after = after,
    before = before,
    filter = filter
  )
  oai_query_list(
    ep = c("vector_stores", vector_store_id, "files_batches", batch_id, "files"),
    headers = openai_beta_header(),
    method = "GET",
    query = query,
    .classify_response = .classify_response,
    .async = .async
  )
}

#' VectorStoreFilesBatch R6 class
#'
#' @field id Character. The ID of the file batch.
#' @field attributes List. The attributes of the file batch.
#' @field created_at POSIXct. The date and time the file batch was created.
#' @field vector_store_id Character. The ID of the vector store where the file batch was created.
#' @field status Character. The status of the file batch.
#' @field file_counts List. The number of files in the batch.
#' @param vector_store_id Character. The ID of the vector store where the file batch will be created.
#' @param file_ids Character. A vector of file IDs to include in the batch.
#' @param paths Character. A vector of file paths to include in the batch.
#' @param batch_id Character. The ID of the batch to retrieve.
#' @param resp List. The response from the API.
#' @param ... Additional arguments passed to the API functions.
#' @importFrom R6 R6Class
#' @export
VectorStoreFilesBatch <- R6Class(
  "VectorStoreFilesBatch",
  portable = FALSE,
  inherit = Utils,
  private = list(
    schema = list(
      as_is = c("id", "attributes", "vector_store_id", "status", "file_counts"),
      as_time = c("created_at")
    )
  ),
  public = list(
    #' @description Initialize a VectorStoreFilesBatch object. The `...` argument is passed to the API functions.
    initialize = function(vector_store_id = NULL,
                          batch_id = NULL,
                          file_ids = NULL,
                          paths = NULL,
                          ...,
                          resp = NULL) {
      if (!is.null(resp)) {
        store_response(resp)
      } else if (!is.null(batch_id)) {
        oai_retrieve_vector_store_file_batch(
          vector_store_id = vector_store_id,
          batch_id = batch_id,
          .classify_response = FALSE
        ) |>
          store_response()
      } else if (!is.null(vector_store_id) && !is.null(file_ids)) {
        oai_create_vector_store_file_batch(
          vector_store_id = vector_store_id,
          file_ids = file_ids,
          .classify_response = FALSE
        ) |>
          store_response()
      } else if (!is.null(vector_store_id) && !is.null(paths)) {
        file_ids <- sapply(paths, function(path) {
          oai_upload_file(path = path, purpose = "assistants")$id
        })
        oai_create_vector_store_file_batch(
          vector_store_id = vector_store_id,
          file_ids = file_ids,
          ...,
          .classify_response = FALSE
        ) |>
          store_response()
      }
    },
    id = NULL,
    attributes = NULL,
    created_at = NULL,
    vector_store_id = NULL,
    status = NULL,
    file_counts = NULL,
    #' @description Retrieve the file batch.
    retrieve = function() {
      oai_retrieve_vector_store_file_batch(
        vector_store_id = self$vector_store_id,
        batch_id = self$id,
        .classify_response = FALSE,
        .async = .async
      ) |>
        store_response()
    },
    #' @description Cancel the file batch.
    cancel = function() {
      oai_cancel_vector_store_file_batch(
        vector_store_id = self$vector_store_id,
        batch_id = self$id,
        .async = .async
      )
    },
    #' @description Delete the file batch.
    delete = function() {
      oai_delete_vector_store_file_batch(
        vector_store_id = self$vector_store_id,
        batch_id = self$id,
        .async = .async
      )
    },
    #' @description List all files in the file batch. The `...` argument is passed to `oai_list_vector_store_files()`.
    list_files = function(...) {
      args <- list(batch_id = self$id,
                   vector_store_id = self$vector_store_id,
                   .classify_response = FALSE,
                    .async = .async,
                   ...)
      do.call(oai_modify_vector_store, args) |>
        store_response()
    },
    #' @description Print the file batch.
    print = function(...) {
      .print(
        "id" = self$id,
        "created_at" = format(self$created_at),
        "vector_store_id" = self$vector_store_id,
        "status" = self$status,
        "file_counts" = self$file_counts
      )
    }
  )
)

