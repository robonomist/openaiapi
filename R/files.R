#' Files API
#'
#' Files are used to upload documents that can be used with features like Assistants, Fine-tuning, and Batch API.
#'
#' @param path Character. The path to the file to upload.
#' @param purpose Character.
#' * `oai_upload_file()`: The purpose of the file (e.g., "assistants", "vision", "batch", "fine-tune").
#' * `oai_list_files()`: Optional. The purpose of the files to list.
#' @param name Character. Optional. The name of the file. If not provided, the file name will be used.
#' @param .classify_response Logical. Whether to classify the response as an R6 object.
#' @return A File R6 object
#' @inheritParams common_parameters
#' @importFrom curl form_file
#' @name files_api
NULL


#' @description * `oai_upload_file()` Upload a file to OpenAI.
#' @export
#' @rdname files_api
oai_upload_file <- function(path,
                            purpose = c("assistants", "vision", "batch", "fine-tune"),
                            name = NULL,
                            .classify_response = TRUE,
                            .async = FALSE) {
  body <- list(
    file = form_file(path, name = name),
    purpose = match.arg(purpose)
  )
  oai_query(
    ep = "files",
    method = "POST",
    body = body,
    encode = "multipart",
    headers = list("Content-Type" = "multipart/form-data"),
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_list_files()` List all files uploaded to OpenAI.
#' @param purpose Character. Optional. Only list files with the specified purpose.
#' @param limit Integer. Optional. The maximum number of files to list. Defaults to 10,000.
#' @param order Character. Optional. The order to list files. Can be "asc" or "desc".
#' @param after Character. Optional. The ID of the file to start the list from.
#' @return File R6 object
#' @export
#' @rdname files_api
oai_list_files <- function(purpose = NULL,
                           limit = NULL,
                           order = NULL,
                           after = NULL,
                           .classify_response = TRUE) {
  query <- list(
    purpose = purpose,
    limit = limit,
    order = order,
    after = after
  ) |> compact()
  oai_query_list(
    ep = "files",
    method = "GET",
    query = query
  )
}

#' @description * `oai_retrieve_file()` Retrieve a specific file from OpenAI.
#'
#' @param file_id Character. The ID of the file to delete.
#' @return  File R6 object
#' @export
#' @rdname files_api
oai_retrieve_file <- function(file_id,
                              .classify_response = TRUE,
                              .async = FALSE) {
  oai_query(
    ep = c("files", file_id),
    .classify_response = .classify_response,
    .async = .async
  )
}

#' Delete a specific file from OpenAI
#' @return Deletion status
#' @export
#' @rdname files_api
oai_delete_file <- function(file_id, .async = FALSE) {
  oai_query(
    ep = c("files", file_id),
    method = "DELETE",
    .classify_response = FALSE,
    .async = .async
  )
}

#' @description * `oai_retrieve_file_content()` Retrieve the content of a specific file from OpenAI.
#'
#' @return The response from the API.
#' @export
#' @rdname files_api
oai_retrieve_file_content <- function(file_id, path, .async = FALSE) {
  oai_query(
    ep = c("files", file_id, "content"),
    path = path,
    .async = .async
  )
}


#' OpenAI File Interface
#'
#' This class provides methods to interact with files in the OpenAI API.
#' @param file_id The ID of the file to initialize.
#' @param path The path to the file to upload.
#' @param ... Additional arguments passed to the API functions.
#' @param resp A list containing the file properties from the API response.
#' @param .async Logical. If TRUE, the function will return a promise.
#' @importFrom R6 R6Class
#' @export
File <- R6Class(
  "File",
  portable = FALSE,
  inherit = Utils,
  private = list(
    schema = list(
      as_is = c("id", "bytes", "filename", "purpose"),
      as_time = "created_at"
    )
  ),

  public = list(
    #' @description Initializes the File object
    #'
    #' @return An instance of the File class.
    initialize = function(file_id = NULL, path = NULL, ...,
                          resp = NULL, .async = FALSE) {
      if (!is.null(resp)) {
        store_response(resp)
      } else if (!is.null(file_id)) {
        oai_retrieve_file(file_id = file_id,
                          .classify_response = FALSE,
                          .async = .async) |>
          store_response()
      } else if (!is.null(path)) {
        oai_upload_file(path = path,
                        ...,
                        .classify_response = FALSE,
                        .async = .async) |>
          store_response()
      }
    },
    #' @field id The ID of the file.
    id = NULL,
    #' @field bytes The size of the file in bytes.
    bytes = NULL,
    #' @field created_at The creation time of the file.
    created_at = NULL,
    #' @field filename The name of the file.
    filename = NULL,
    #' @field purpose The purpose of the file.
    purpose = NULL,
    #' Retrieve the file's properties from the API
    #'
    #' @return The up-to-date File instance.
    retrieve = function() {
      oai_retrieve_file(file_id = self$id,
                        .classify_response = FALSE,
                        .async = .async) |>
        store_response()
    },
    #' Delete the file
    #'
    #' @return NULL
    delete = function() {
      oai_delete_file(file_id = self$id)
    },
    #' Print the file's details
    #'
    #' @param ... Additional arguments (unused).
    #' @return The File instance.
    print = function(...) {
      cat("File:\n")
      cat("id:", self$id, "\n")
      cat("filename:", self$filename, "\n")
      cat("created_at:", format(self$created_at), "\n")
      invisible(self)
    }
  )
)
