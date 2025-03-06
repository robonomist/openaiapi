#' Thread Messages API
#'
#' Manage messages within threads
#' @inheritParams common_parameters
#' @name message_api
NULL

#' @description * `oai_create_message()` Create a message in a thread.
#'
#' @param thread_id Character. The ID of the thread.
#' @param content Character. The content of the message.
#' @param role Character. The role of the sender.
#' @param attachments List or NULL. Optional. Attachments to include with the message.
#' @param metadata List or NULL. Optional. Metadata to include with the message.
#' @return A Message R6 object.
#' @export
#' @rdname message_api
#' @order 1
oai_create_message <- function(thread_id,
                               content,
                               role = c("user", "assistant"),
                               attachments = NULL,
                               metadata = NULL,
                               .classify_response = TRUE) {
  body <- list(
    role = match.arg(role),
    content = content,
    attachments = attachments,
    metadata = metadata
  ) |> compact()
  oai_query(
    c("threads", thread_id, "messages"),
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response
  )
}

#' @description * `oai_list_messages()` List messages in a thread.
#'
#' @return `oai_list_messages()` returns a list of messages in a thread.
#' @export
#' @rdname message_api
oai_list_messages <- function(thread_id,
                              limit = NULL,
                              order = NULL,
                              after = NULL,
                              before = NULL,
                              .classify_response = TRUE) {
  query <- list(
    limit = as.integer(limit),
    order = order,
    after = after,
    before = before
  ) |> compact()
  oai_query_list(
    c("threads", thread_id, "messages"),
    headers = openai_beta_header(),
    method = "GET",
    query = query,
    .classify_response = .classify_response
  )
}


#' @description * `oai_retrieve_message()` Retrieve a message.
#'
#' @param message_id Character. The ID of the message.
#' @export
#' @rdname message_api
oai_retrieve_message <- function(thread_id,
                                 message_id,
                                 .classify_response = TRUE) {
  oai_query(
    c("threads", thread_id, "messages", message_id),
    headers = openai_beta_header(),
    .classify_response = .classify_response
  )
}

#' @description * `oai_modify_message()` Modify a message.
#' @export
#' @rdname message_api
oai_modify_message <- function(thread_id,
                               message_id,
                               metadata = NULL,
                               .classify_response = TRUE) {
  body <- list(
    metadata = metadata
  ) |> compact()
  oai_query(
    c("threads", thread_id, "messages", message_id),
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response
  )
}

#' @description * `oai_delete_message()` Delete a message.
#' @return `oai_delete_message()` returns the deletion status.
#' @export
#' @rdname message_api
oai_delete_message <- function(thread_id, message_id) {
  oai_query(
    c("threads", thread_id, "messages", message_id),
    headers = openai_beta_header(),
    method = "DELETE"
  )
}

#' Message R6 class
#' @field id Character. The ID of the message.
#' @field created_at POSIXct. The time the message was created.
#' @field thread_id Character. The ID of the thread this message belongs to.
#' @field status Character. The status of the message.
#' @field incomplete_details List. Details about the message if it is incomplete.
#' @field completed_at POSIXct. The time the message was completed.
#' @field incomplete_at POSIXct. The time the message was marked as incomplete.
#' @field role Character. The role of the sender.
#' @field content List. The content of the message.
#' @field assistant_id Character. If applicable, the ID of the assistant that authored this message.
#' @field run_id Character. The ID of the run associated with the creation of this message. Value is null when messages are created manually using the create message or create thread endpoints.
#' @field attachments List. Attachments to the message.
#' @field metadata List. Metadata associated with the message.
#' @param message_id Character. The ID of the message.
#' @param thread_id Character. The ID of the thread.
#' @param resp List. The response from the OpenAI API.
#' @param ... Additional parameters passed to the API call.
#' @export
#' @importFrom R6 R6Class
Message <- R6Class(
  "Message",
  portable = FALSE,
  public = list(
    #' @description Initialize a Message object.
    initialize = function(message_id = NULL,
                          thread_id = NULL,
                          ...,
                          resp = NULL) {
      if (!is.null(resp)) {
        id <<- resp$id
        created_at <<- resp$created_at |> as_time()
        thread_id <<- resp$thread_id
        status <<- resp$status
        incomplete_details <<- resp$incomplete_details
        completed_at <<- resp$completed_at |> as_time()
        incomplete_at <<- resp$incomplete_at |> as_time()
        role <<- resp$role
        content <<- resp$content
        assistant_id <<- resp$assistant_id
        run_id <<- resp$run_id
        attachments <<- resp$attachments
        metadata <<- resp$metadata
      } else if (!is.null(message_id)) {
        oai_retrieve_message(
          message_id, .classify_response = FALSE, ...
        ) |>
          initialize(resp = _)
      } else if (!is.null(thread_id)) {
        oai_create_message(
          thread_id, ..., .classify_response = FALSE
        ) |>
          initialize(resp = _)
      } else {
        cli_abort("Either `message_id` or `thread_id` must be provided.")
      }
    },
    id = NULL,
    created_at = NULL,
    thread_id = NULL,
    status = NULL,
    incomplete_details = NULL,
    completed_at = NULL,
    incomplete_at = NULL,
    role = NULL,
    content = NULL,
    assistant_id = NULL,
    run_id = NULL,
    attachments = NULL,
    metadata = NULL,
    #' @description Retrieve the message.
    retrieve = function() {
      oai_retrieve_message(
        thread_id = self$thread_id,
        message_id = self$id,
        .classify_response = FALSE) |>
        initialize(resp = _)
      self
    },
    #' @description Modify the message metadata.
    modify = function(...) {
      oai_modify_message(
        thread_id = self$thread_id,
        message_id = self$message_id,
        ...,
        .classify_response = FALSE) |>
        initialize(resp = _)
      self
    },
    #' @description Delete the message.
    delete = function() {
      oai_delete_message(
        thread_id = self$thread_id,
        message_id = self$id
      )
    },
    #' @description Get the text content of the message.
    content_text = function() {
      self$content |>
        lapply(function(x) x$text$value) |>
        unlist() |>
        paste(collapse = "\n\n")
    },
    #' @description Get the thread this message belongs to.
    thread = function() {
      oai_retrieve_thread(thread_id = self$thread_id)
    },
    #' @description Get the assistant if applicable.
    assistant = function() {
      if (!is.null(self$assistant_id)) {
        oai_retrieve_assistant(assistant_id = self$assistant_id)
      }
    }
  )
)
