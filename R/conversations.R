#' Conversations API
#'
#' Based on the OpenAI API openapi specification.
#' @inheritParams common_parameters
#' @name conversations
NULL

#' @description Create a conversation
#' @param items List. Initial items to seed the conversation with. You may add up to 20 items at a time.
#' @return * `oai_create_conversation()` - A `Conversation` object.
#' @export
#' @rdname conversations
oai_create_conversation <- function(items = NULL,
                                    metadata = NULL,
                                    .classify_response = TRUE,
                                    .async = FALSE) {
  body <- list(
    items = items,
    metadata = metadata
  )
  oai_query(
    ep = "conversations",
    method = "POST",
    body = body,
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description Retrieve a conversation
#' @param conversation_id Character. The ID of the conversation.
#' @return * `oai_get_conversation()` - A `Conversation` object.
#' @export
#' @rdname conversations
oai_get_conversation <- function(conversation_id,
                                 .classify_response = TRUE,
                                 .async = FALSE) {
  oai_query(
    ep = paste0("conversations/", conversation_id),
    method = "GET",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description Update a conversation
#'
#' @return * `oai_update_conversation()` - The updated `Conversation` object.
#' @export
#' @rdname conversations
oai_update_conversation <- function(conversation_id,
                                    metadata = NULL,
                                    .classify_response = TRUE,
                                    .async = FALSE) {
  body <- list(
    metadata = metadata
  )
  oai_query(
    ep = paste0("conversations/", conversation_id),
    method = "POST",
    body = body,
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description Delete a conversation
#'
#' @return * `oai_delete_conversation()` - A success message.
#' @export
#' @rdname conversations
oai_delete_conversation <- function(conversation_id,
                                    .async = FALSE) {
  oai_query(
    ep = paste0("conversations/", conversation_id),
    method = "DELETE",
    .classify_response = FALSE,
    .async = .async
  )
}

#' @description List conversation items
#'
#' @param include Character vector. Specify additional output data to include in the model response.
#' @return * `oai_list_conversation_items()` - A list object containing Conversation items.
#' @export
#' @rdname conversations
oai_list_conversation_items <- function(conversation_id,
                                        limit = 20,
                                        order = c("desc", "asc"),
                                        after = NULL,
                                        include = NULL,
                                        .classify_response = TRUE,
                                        .async = FALSE) {
  query <- list(
    limit = limit,
    order = match.arg(order),
    after = after,
    include = include
  )
  oai_query(
    ep = paste0("conversations/", conversation_id, "/items"),
    method = "GET",
    query = query,
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description Create conversation items
#' @param items List. The items to add to the conversation. You may add up to 20 items at a time.
#' @return * `oai_create_conversation_items()` - The list of added items.
#' @export
#' @rdname conversations
oai_create_conversation_items <- function(conversation_id,
                                          items,
                                          include = NULL,
                                          .classify_response = TRUE,
                                          .async = FALSE) {
  body <- list(
    items = items
  )
  query <- list(
    include = include
  )
  oai_query(
    ep = paste0("conversations/", conversation_id, "/items"),
    body = body,
    method = "POST",
    query = query,
    .classify_response = .classify_response,
    .async = .async
  )
  oai_query(
    ep = paste0("conversations/", conversation_id, "/items"),
    method = "POST",
    body = body,
    query = query,
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description Retrieve an conversation item
#'
#' @param item_id Character. The ID of the conversation item.
#' @return * `oai_retrieve_conversation_item()` - A conversation item.
#' @export
#' @rdname conversations
oai_retrieve_conversation_item <- function(conversation_id,
                                           item_id,
                                           include = NULL,
                                           .classify_response = TRUE,
                                           .async = FALSE) {
  query <- list(
    include = include
  )
  oai_query(
    ep = paste0("conversations/", conversation_id, "/items/", item_id),
    method = "GET",
    query = query,
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description Delete a conversation item
#'
#' @return * `oai_delete_conversation_item()` - An updated `Conversation` object.
#' @export
#' @rdname conversations
oai_delete_conversation_item <- function(conversation_id,
                                         item_id,
                                         .classify_response = TRUE,
                                         .async = FALSE) {
  oai_query(
    ep = paste0("conversations/", conversation_id, "/items/", item_id),
    method = "DELETE",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' Conversation R6 Class
#'
#' @description An R6 class representing a Conversation in the OpenAI API.
#' @param conversation_id Character. The ID of the conversation.
#' @param resp A list. The object returned by the OpenAI API.
#' @param ... Additional arguments to be passed to the API functions.
#' @param item_id Character. The ID of a specific conversation item.
#' @export
Conversation <- R6Class(
  "Conversation",
  inherit = Utils,
  portable = FALSE,
  private = list(
    schema = list(
      as_is = c("id", "object", "metadata"),
      time = "created_at"
    )
  ),
  public = list(
    #' @description Initialize a Conversation object
    initialize = function(conversation_id = NULL,
                          ...,
                          resp = NULL) {
      if (!is.null(resp)) {
        store_response(resp)
      } else if (!is.null(conversation_id)) {
        id <<- conversation_id
        self$retrieve()
      } else {
        oai_create_conversation(
          ...,
          .classify_response = FALSE,
        ) |>
          store_response()
      }
    },
    #' @field id The conversation ID.
    id = NULL,
    #' @field object The object type, which is "conversation".
    object = NULL,
    #' @field created_at The creation time of the conversation, in epoch seconds.
    created_at = NULL,
    #' @field metadata Metadata associated with the conversation.
    metadata = NULL,
    #' @description Retrieve a fresh copy of the conversation from the API
    retrieve = function() {
      oai_get_conversation(
        conversation_id = self$id,
        .classify_response = FALSE,
        .async = .async
      ) |>
        self$store_response()
    },
    #' @description Update the conversation's metadata
    update = function(...) {
      oai_update_conversation(
        conversation_id = self$id,
        ...,
        .classify_response = FALSE,
        .async = .async
      ) |>
        self$store_response()
    },
    #' @description Delete the conversation
    delete = function() {
      oai_delete_conversation(
        conversation_id = self$id,
        .async = .async
      )
    },
    #' @description List items in the conversation
    list_items = function(...) {
      oai_list_conversation_items(
        conversation_id = self$id,
        ...,
        .async = .async
      )
    },
    #' @description Add items to the conversation
    create_items = function(...) {
      oai_create_conversation_items(
        conversation_id = self$id,
        ...,
        .async = .async
      )
    },
    #' @description Retrieve a specific item from the conversation
    retrieve_item = function(item_id, ...) {
      oai_retrieve_conversation_item(
        conversation_id = self$id,
        item_id = item_id,
        ...,
        .async = .async
      )
    },
    #' @description Delete a specific item from the conversation
    delete_item = function(item_id) {
      oai_delete_conversation_item(
        conversation_id = self$id,
        item_id = item_id,
        .async = .async
      )
    }
  )
)


