#' Threads API
#'
#' Manage threads that assistants can interact with.
#' @name thread_api
#' @inheritParams oai_create_assistant
NULL

#' @description * `oai_create_thread()`: Create a new thread that assistants can interact with.
#'
#' @param messages A list of oai_messages to start the thread with.
#' @param tool_resources A list of tool resources that are available to the assistant.
#' @rdname thread_api
#' @export
oai_create_thread <- function(messages = NULL,
                              tool_resources = NULL,
                              metadata = NULL,
                              .classify_response = TRUE) {
  body <- list(
    messages = messages,
    tool_resources = tool_resources,
    metadata = metadata
  )
  oai_query(
    "threads",
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response
  )
}

#' @description * `oai_modify_thread()`: Modify a thread.
#' @param thread_id The ID of the thread.
#' @rdname thread_api
#' @export
oai_modify_thread <- function(thread_id,
                              tool_resources = NULL,
                              metadata = NULL,
                              .classify_response = TRUE) {
  body <- list(
    tool_resources = tool_resources,
    metadata = metadata
  )
  oai_query(
    c("threads", thread_id),
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response
  )
}

#' @description * `oai_retrieve_thread()`: Retrieve a thread.
#' @rdname thread_api
#' @export
oai_retrieve_thread <- function(thread_id,
                                .classify_response = TRUE,
                                .async = FALSE) {
  oai_query(
    c("threads", thread_id),
    headers = openai_beta_header(),
    method = "GET",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_delete_thread()`: Delete a thread.
#' @rdname thread_api
#' @export
oai_delete_thread <- function(thread_id) {
  oai_query(
    c("threads", thread_id),
    headers = openai_beta_header(),
    method = "DELETE"
  )
}

#' Thread R6 class
#'
#' @param resp A response from the OpenAI API.
#' @param thread_id The ID of the thread.
#' @param assistant_id The assistant to run the thread on. Can be an Assistant object or an assistant ID.
#' @param content The content of the message.
#' @param role The role of the message. Can be "user" or "assistant".
#' @param ... Additional arguments passed to the API functions.
#' @importFrom R6 R6Class
#' @export
Thread <- R6Class(
  "Thread",
  portable = FALSE,
  public = list(
    #' @description Initialize the thread. If `thread_id` is provided, the thread is retrieved from the API. The `...` argument is passed to `oai_create_thread()`.
    initialize = function(thread_id = NULL, ..., resp = NULL) {
      if (!is.null(resp)) {
        id <<- resp$id
        created_at <<- as.POSIXct(resp$created_at, tz = "UTC")
        metadata <<- resp$metadata
      } else if (!is.null(thread_id)) {
        id <<- thread_id
        self$retrieve()
      } else {
        args <- list(...)
        args$.classify_response <- FALSE
        do.call(oai_create_thread, args) |> initialize(resp = _)
      }
    },
    #' @field id The ID of the thread.
    id = NULL,
    #' @field created_at The time the thread was created.
    created_at = NULL,
    #' @field metadata Additional metadata about the thread.
    metadata = NULL,
    #' @description Modify the thread. The `...` argument is passed to `oai_modify_thread()`.
    modify = function(...) {
      oai_modify_thread(thread_id = self$id,
                        ...,
                        .classify_response = FALSE) |>
        initialize(resp = _)
      self
    },
    #' @description Retrieve the thread. The `...` argument is passed to `oai_retrieve_thread()`.
    retrieve = function(...) {
      oai_retrieve_thread(thread_id = self$id,
                          ...,
                          .classify_response = FALSE) |>
        initialize(resp = _)
      self
    },
    #' @description Delete the thread.
    delete = function() {
      oai_delete_thread(thread_id = self$id)
    },
    #' @description Create a new message in the thread. The `...` argument is passed to `oai_create_message()`.
    #' @return `create_message()` returns the thread object.
    create_message = function(content,
                              role = "user", ...) {
      oai_create_message(
        thread_id = self$id,
        role = role,
        content = content, ...
      )
      self
    },
    #' @description List messages in the thread. The `...` argument is passed to `oai_list_messages()`.
    list_messages = function(...) {
      oai_list_messages(thread_id = self$id, ...)
    },
    #' @description Run the thread on an assistant. The `...` argument is passed to `oai_create_run()`.
    run = function(assistant_id, ...) {
      if (inherits(assistant_id, "Assistant")) {
        assistant_id <- assistant_id$id
      }
      args <- list(assistant_id = assistant_id, thread_id = self$id, ...)
      do.call(oai_create_run, args)
    },
    #' @description List runs of the thread. The `...` argument is passed to `oai_list_runs()`.
    list_runs = function(...) {
      oai_list_runs(thread_id = self$id, ...)
    }
  )
)
