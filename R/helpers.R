#' A helper function for message arguments
#'
#' @param content Character. The content of the message.
#' @param role Character. The role of the sender (default is "user").
#' @param attachments List or NULL. Optional. Attachments to include with the message.
#' @param metadata List or NULL. Optional. Metadata to include with the message.
#' @param ... Additional values to pass to the API.
#' @return A structured list representing the message.
#' @rdname utils
#' @export
oai_message <- function(content,
                        role = "user",
                        attachments = NULL,
                        metadata = NULL,
                        ...) {
  stopifnot(length(content) == 1L)
  if (inherits(attachments, "oai_attachment")) {
    attachments <- list(attachments)
  }
  list(
    role = role,
    content = content,
    attachments = attachments,
    metadata = metadata,
    ...
  ) |>
    compact() |>
    structure(class = "oai_message")
}


#' A helper function for the `attachment` argument in `oai_create_message()` and `Message` objects.
#' @param file_id Character. The ID of the file.
#' @param tools Character. The tools to use with the attachment.
#' @export
#' @rdname message_api
#' @order 10
oai_attachment <- function(file_id,
                           tools = c("code_interpreter", "file_search")) {
  if (inherits(file_id, "File")) {
    file_id <- file_id$id
  }
  tools <- match.arg(tools)
  list(
    file_id = file_id,
    tools = list(type = tools)
  ) |>
    compact() |>
    structure(class = "oai_attachment")
}


#' A helper function for thread arguments
#'
#' @param messages A list of oai_message objects or a character vector.
#' @param tool_resources List. Optional. A list of tool resources to include with the thread.
#' @param metadata List or NULL. Optional. Metadata to include with the thread.
#' @export
#' @rdname utils
oai_thread <- function(messages,
                       tool_resources = NULL,
                       metadata = NULL) {
  if (inherits(messages, "oai_message")) {
    messages <- list(messages)
  } else if (is.character(messages)) {
    messages <- list(oai_message(paste(messages, collapse = "\n")))
  }
  list(
    messages = messages,
    tool_resources = tool_resources,
    metadata = metadata
  ) |>
    compact() |>
    structure(class = "oai_thread")
}

#' A helper function for tool resource arguments
#'
#' @param code_interpreter_file_ids, Character A vector of file IDs fore the code interpreter to use.
#' @param vector_store_ids, Character A vector of vector store IDs for the file search to use.
#' @export
#' @rdname utils
oai_tool_resource <- function(code_interpreter_file_ids = NULL,
                              vector_store_ids = NULL) {
  list(
    code_interpreter = list(
      file_ids = code_interpreter_file_ids
    ),
    list(
      file_search = list(
        vector_store_ids = vector_store_ids
      )
    )
  ) |>
    compact() |>
    structure(class = "oai_tool_resource")
}
