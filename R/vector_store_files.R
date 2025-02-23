#' Vector store files API
#'
#' Vector store files represent files inside a vector store.
#' @inheritParams oai_create_vector_store
#' @return VectorStoreFile R6 object.
#' @name vector_store_file_api
NULL

#' @description * `oai_create_vector_store_file()`: Create a new file in a vector store.
#'
#' @param vector_store_id Character. The ID of the vector store where the file will be created.
#' @param file_id Character. The ID of the file to be added to the vector store.
#' @param chunking_strategy List. Optional. Strategy for chunking data.
#' @rdname vector_store_file_api
#' @export
oai_create_vector_store_file <- function(vector_store_id,
                                         file_id,
                                         chunking_strategy = NULL,
                                         .classify_response = TRUE) {
  body <- list(
    file_id = file_id,
    chunking_strategy = chunking_strategy
  ) |> compact()
  oai_query(
    ep = c("vector_stores", vector_store_id, "files"),
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response
  )
}

#' @description * `oai_list_vector_store_files()`: List files in a vector store.
#'
#' @param vector_store_id Character. The ID of the vector store to list files from.
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
                                        .classify_response = TRUE) {
  query <- list(
    limit = as.integer(limit),
    order = order,
    after = after,
    before = before,
    filter = filter
  ) |> compact()
  oai_query(
    ep = c("vector_stores", vector_store_id, "files"),
    headers = openai_beta_header(),
    method = "GET",
    query = query,
    .classify_response = .classify_response
  )
}

#' @description * `oai_retrieve_vector_store_file()`: Retrieve a specific file from a vector store.
#'
#' @rdname vector_store_file_api
#' @export
oai_retrieve_vector_store_file <- function(vector_store_id, file_id) {
  oai_query(
    c("vector_stores", vector_store_id, "files", file_id),
    headers = openai_beta_header()
  )
}

#' @description * `oai_delete_vector_store_file()`: Delete a file from a vector store.
#'
#' @return Deletion status.
#' @rdname vector_store_file_api
#' @export
oai_delete_vector_store_file <- function(vector_store_id, file_id) {
  oai_query(
    c("vector_stores", vector_store_id, "files", file_id),
    headers = openai_beta_header(),
    method = "DELETE"
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
  public = list(
    #' @description Initialize a new VectorStoreFile object.
    #' Either provide a vector_store_file_id or a vector_store_id together with a file_id or a path to a file.
    initialize = function(vector_store_file_id = NULL,
                          vector_store_id = NULL,
                          file_id = NULL,
                          path = NULL,
                          resp = NULL) {
      if (!is.null(resp)) {
        id <<- resp$id
        created_at <<- resp$created_at |> as_time()
        usage_bytes <<- resp$usage_bytes
        vector_store_id <<- resp$vector_store_id
        status <<- resp$status
        last_error <<- resp$last_error
        chunking_strategy <<- resp$chunking_strategy
      } else if (!is.null(vector_store_file_id)) {
        oai_retrieve_vector_store_file(
          vector_store_id = vector_store_id,
          file_id = vector_store_file_id
        ) |>
          initialize(resp = _)
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
          initialize(resp = _)
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
          initialize(resp = _)
      } else {
        stop("Either provide a response object or vector_store_id and file_id")
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
        file_id = self$id
      ) |>
        initialize()
      self
    },
    #' @description Delete the vector store file from the OpenAI API.
    delete = function() {
      oai_delete_vector_store_file(
        vector_store_id = self$vector_store_id,
        file_id = self$id
      )
    },
    #' @description Print the vector store file.
    print = function(...) {
      cat("Vector store file:\n")
      cat("id:", self$id, "\n")
      cat("vector_store_id:", self$vector_store_id, "\n")
      cat("created_at:", format(self$created_at), "\n")
      cat("usage_bytes:", self$usage_bytes, "\n")
      cat("status:", self$status, "\n")
      invisible(self)
    }
  )
)
