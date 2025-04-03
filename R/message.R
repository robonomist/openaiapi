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
                               .classify_response = TRUE,
                               .async = FALSE) {
  body <- list(
    role = match.arg(role),
    content = content,
    attachments = attachments,
    metadata = metadata
  )
  oai_query(
    c("threads", thread_id, "messages"),
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response,
    .async = .async
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
                              .classify_response = TRUE,
                              .async = FALSE) {
  query <- list(
    limit = limit,
    order = order,
    after = after,
    before = before
  )
  oai_query_list(
    c("threads", thread_id, "messages"),
    headers = openai_beta_header(),
    method = "GET",
    query = query,
    .classify_response = .classify_response,
    .async = .async
  )
}


#' @description * `oai_retrieve_message()` Retrieve a message.
#'
#' @param message_id Character. The ID of the message.
#' @export
#' @rdname message_api
oai_retrieve_message <- function(thread_id,
                                 message_id,
                                 .classify_response = TRUE,
                                 .async = FALSE) {
  oai_query(
    c("threads", thread_id, "messages", message_id),
    headers = openai_beta_header(),
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_modify_message()` Modify a message.
#' @export
#' @rdname message_api
oai_modify_message <- function(thread_id,
                               message_id,
                               metadata = NULL,
                               .classify_response = TRUE,
                               .async = FALSE) {
  body <- list(
    metadata = metadata
  )
  oai_query(
    c("threads", thread_id, "messages", message_id),
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_delete_message()` Delete a message.
#' @return `oai_delete_message()` returns the deletion status.
#' @export
#' @rdname message_api
oai_delete_message <- function(thread_id, message_id, .async = FALSE) {
  oai_query(
    c("threads", thread_id, "messages", message_id),
    headers = openai_beta_header(),
    method = "DELETE",
    .classify_response = FALSE,
    .async = .async
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
#' @param .async Logical. If TRUE, the API call will be asynchronous.
#' @export
#' @importFrom R6 R6Class
Message <- R6Class(
  "Message",
  portable = FALSE,
  inherit = Utils,
  private = list(
    schema = list(
      as_is = c("id", "thread_id", "status", "incomplete_details", "role",
                "content", "assistant_id", "run_id", "attachments",
                "metadata"),
      as_time = c("created_at", "completed_at", "incomplete_at")
    )
  ),
  public = list(
    #' @description Initialize a Message object.
    initialize = function(message_id = NULL,
                          thread_id = NULL,
                          ...,
                          resp = NULL,
                          .async = FALSE) {
      if (!is.null(resp)) {
        store_response(resp)
      } else if (!is.null(message_id)) {
        oai_retrieve_message(
          message_id, .classify_response = FALSE, ...,
          .async = .async
        ) |>
          store_response()
      } else if (!is.null(thread_id)) {
        oai_create_message(
          thread_id, ...,
          .classify_response = FALSE,
          .async = .async
        ) |>
          store_response()
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
        .classify_response = FALSE,
        .async = .async
      ) |>
        store_response()
    },
    #' @description Modify the message metadata.
    modify = function(...) {
      oai_modify_message(
        thread_id = self$thread_id,
        message_id = self$message_id,
        ...,
        .classify_response = FALSE,
        .async = .async
      ) |>
        store_response()
    },
    #' @description Delete the message.
    delete = function() {
      oai_delete_message(
        thread_id = self$thread_id,
        message_id = self$id,
        .async = .async
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
      oai_retrieve_thread(thread_id = self$thread_id, .async = .async)
    },
    #' @description Get the assistant if applicable.
    assistant = function() {
      if (!is.null(self$assistant_id)) {
        oai_retrieve_assistant(assistant_id = self$assistant_id,
                               .async = .async)
      }
    },
    #' @description Add message delta
    #' @param delta List. Data from the `thread.message.delta` event.
    add_delta = function(delta) {
      if (!is.null(delta$role)) {
        role <- delta$role
      }
      ## Process content
      for (item in delta$content) {
        i <- item$index + 1L
        if (length(self$content) < i) {
          ## New item
          self$content[[i]] <- item
        } else {
          if (item$type == "text") {
            ## Concatenate text
            item$text$value <- paste0(
              self$content[[i]]$text$value %||% "",
              item$text$value
            )
            ## Process annotations
            for (a in item$text$annotations) {
              j <- a$index + 1L
              if (length(self$content[[i]]$text$annotations) < j) {
                ## New annotation
                self$content[[i]]$text$annotations[[j]] <- a
              } else {
                ## Concatenate annotation text
                a$text <- paste0(
                  self$content[[i]]$text$annotations[[j]]$text %||% "",
                  a$text
                )
                item$text$annotations[[j]] <- modifyList(
                  self$content[[i]]$text$annotations[[j]], a
                )
              }
            }
            self$content[[i]] <- modifyList(self$content[[i]], item)
          }
        }
      }
      NULL
      ## self$content <- c(self$content, delta)
    }
  )
)
