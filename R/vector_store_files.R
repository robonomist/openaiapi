#' Vector store files API
#'
#' Vector store files represent files inside a vector store.
#' @inheritParams oai_create_vector_store
#' @return VectorStoreFile R6 object.
#' @name vector_store_file_api
NULL

#' @description * `oai_create_vector_store_file()`: Create a new file in a vector store.
#'
#' @param vector_store_id Character. The ID of the vector store.
#' @param file_id Character. The ID of the file to be added to the vector store.
#' @param chunking_strategy List. Optional. Strategy for chunking data.
#' @rdname vector_store_file_api
#' @export
oai_create_vector_store_file <- function(vector_store_id,
                                         file_id,
                                         chunking_strategy = NULL,
                                         .classify_response = TRUE,
                                         .async = FALSE) {
  body <- list(
    file_id = file_id,
    chunking_strategy = chunking_strategy
  )
  oai_query(
    ep = c("vector_stores", vector_store_id, "files"),
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_list_vector_store_files()`: List files in a vector store.
#'
#' @param filter Character. Optional. Filter by file status. One of "in_progress", "completed", "failed", "cancelled".
#' @inheritParams oai_list_vector_stores
#' @return A List of VectorStoreFile R6 objects.
#' @rdname vector_store_file_api
#' @export
oai_list_vector_store_files <- function(vector_store_id,
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
    ep = c("vector_stores", vector_store_id, "files"),
    headers = openai_beta_header(),
    method = "GET",
    query = query,
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_retrieve_vector_store_file()`: Retrieve a specific file from a vector store.
#'
#' @rdname vector_store_file_api
#' @export
oai_retrieve_vector_store_file <- function(vector_store_id,
                                           file_id,
                                           .classify_response = TRUE,
                                           .async = FALSE) {
  oai_query(
    c("vector_stores", vector_store_id, "files", file_id),
    headers = openai_beta_header(),
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_update_vector_store_file()`: Update attributes of a vector store file.
#'
#' @param attributes Named list. A list of attributes to update, with a maximum of 16 key-value pairs. Keys are strings with a maximum length of 64 characters. Values are strings with a maximum length of 512 characters, booleans, or numbers.
#' @rdname vector_store_file_api
#' @export
oai_update_vector_store_file <- function(vector_store_id,
                                         file_id,
                                         attributes,
                                         .classify_response = TRUE,
                                         .async = FALSE) {
  body <- list(
    attributes = attributes
  )
  oai_query(
    c("vector_stores", vector_store_id, "files", file_id),
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_delete_vector_store_file()`: Delete a file from a vector store.
#'
#' @return Deletion status.
#' @rdname vector_store_file_api
#' @export
oai_delete_vector_store_file <- function(vector_store_id,
                                         file_id,
                                         .async = FALSE) {
  oai_query(
    c("vector_stores", vector_store_id, "files", file_id),
    headers = openai_beta_header(),
    method = "DELETE",
    .async = .async
  )
}

#' VectorStoreFile R6 class
#'
#' @field id Character. The ID of the vector store file.
#' @field created_at POSIXct. The time the vector store file was created.
#' @field usage_bytes Integer. The number of bytes used by the vector store file.
#' @field vector_store_id Character. The ID of the vector store that the file belongs to.
#' @field status Character. The status of the vector store file. One of "in_progress", "completed", "failed", "cancelled".
#' @field last_error Character. The last error that occurred while processing the file.
#' @field chunking_strategy List. The strategy used to chunk the data.
#' @param vector_store_file_id Character. The ID of the vector store file.
#' @param vector_store_id Character. The ID of the vector store that the file belongs to.
#' @param file_id Character. The ID of the file that the vector store file is associated with.
#' @param path Character. The path to the file that the vector store file is associated with.
#' @param resp List. The response object from the OpenAI API.
#' @param ... Additional arguments passed to API functions.
#' @importFrom R6 R6Class
VectorStoreFile <- R6Class(
  "VectorStoreFile",
  portable = FALSE,
  inherit = Utils,
  private = list(
    schema = list(
      as_is = c("id", "usage_bytes", "vector_store_id", "status", "last_error", "chunking_strategy"),
      as_time = c("created_at")
    )
  ),
  public = list(
    #' @description Initialize a new VectorStoreFile object.
    #' Either provide a vector_store_file_id or a vector_store_id together with a file_id or a path to a file.
    initialize = function(vector_store_file_id = NULL,
                          vector_store_id = NULL,
                          file_id = NULL,
                          path = NULL,
                          resp = NULL) {
      if (!is.null(resp)) {
        store_response(resp)
      } else if (!is.null(vector_store_file_id)) {
        oai_retrieve_vector_store_file(
          vector_store_id = vector_store_id,
          file_id = vector_store_file_id
        ) |>
          store_response()
      } else if (!is.null(vector_store_id) && !is.null(file_id)) {
        if (inherits(file_id, "File")) {
          file_id <- file_id$id
        }
        if (inherits(vector_store_id, "VectorStore")) {
          vector_store_id <- vector_store_id$id
        }
        oai_create_vector_store_file(
          vector_store_id = vector_store_id,
          file_id = file_id,
          .classify_response = FALSE
        ) |>
          store_response()
      } else if (!is.null(vector_store_id) && !is.null(path)) {
        if (inherits(vector_store_id, "VectorStore")) {
          vector_store_id <- vector_store_id$id
        }
        file_id <- oai_create_file(path = path)$id
        oai_create_vector_store_file(
          vector_store_id = vector_store_id,
          file_id = file_id,
          .classify_response = FALSE
        ) |>
          store_response()
      } else {
        cli_abort(c(
          "You must provide one of the following:",
          "*" = "a vector_store_file_id",
          "*" = "a vector_store_id and a file_id",
          "*" = "a vector_store_id and a path to a file"
        ))
      }
    },
    id = NULL,
    created_at = NULL,
    usage_bytes = NULL,
    vector_store_id = NULL,
    status = NULL,
    last_error = NULL,
    chunking_strategy = NULL,
    #' @description Retrieve the vector store file from the OpenAI API.
    retrieve = function() {
      oai_retrieve_vector_store_file(
        vector_store_id = self$vector_store_id,
        file_id = self$id,
        .classify_response = FALSE,
        .async = .async
      ) |>
        store_response()
    },
    #' @description Update the vector store file in the OpenAI API.
    #' @param attributes Named list. A list of attributes to update, with a maximum of 16 key-value pairs. Keys are strings with a maximum length of 64 characters. Values are strings with a maximum length of 512 characters, booleans, or numbers.
    update = function(attributes) {
      oai_update_vector_store_file(
        vector_store_id = self$vector_store_id,
        file_id = self$id,
        attributes = attributes,
        .classify_response = FALSE,
        .async = .async
      ) |>
        store_response()
    },
    #' @description Delete the vector store file from the OpenAI API.
    delete = function() {
      oai_delete_vector_store_file(
        vector_store_id = self$vector_store_id,
        file_id = self$id,
        .async = .async
      )
    },
    #' @description Print the vector store file.
    print = function(...) {
      .print(
        "id" = self$id,
        "vector_store_id" = self$vector_store_id,
        "created_at" = format(self$created_at),
        "usage_bytes" = self$usage_bytes,
        "status" = self$status
      )
    }
  )
)
