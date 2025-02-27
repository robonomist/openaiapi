#' Chat completion API
#'
#' @param messages A list of messages comprising the conversation so far. You can also pass a oai_message object or a character vector.
#' @param model Character. ID of the model to use. See the model endpoint compatibility table for details on which models work with the Chat API.
#' @param frequency_penalty Numeric. Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
#' @param logit_bias List. Modify the likelihood of specified tokens appearing in the completion.
#' @param logprobs Logical. Whether to return log probabilities of the output tokens or not. If true, returns the log probabilities of each output token returned in the content of message.
#' @param top_logprobs Integer. An integer between 0 and 20 specifying the number of most likely tokens to return at each token position, each with an associated log probability. logprobs must be set to true if this parameter is used.
#' @param max_tokens Integer. The maximum number of tokens that can be generated in the chat completion.
#' @param n Integer. How many chat completion choices to generate for each input message. Note that you will be charged based on the number of generated tokens across all of the choices. Keep n as 1 to minimize costs.
#' @param presence_penalty Numeric. Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.
#' @param response_format List. An object specifying the format that the model must output. Compatible with GPT-4o, GPT-4o mini, GPT-4 Turbo and all GPT-3.5 Turbo models newer than gpt-3.5-turbo-1106.
#' @param seed Integer. If specified, our system will make a best effort to sample deterministically, such that repeated requests with the same seed and parameters should return the same result. Determinism is not guaranteed, and you should refer to the system_fingerprint response parameter to monitor changes in the backend.
#' @param service_tier Character. Specifies the latency tier to use for processing the request. This parameter is relevant for customers subscribed to the scale tier service.
#' @param stop Character. Up to 4 sequences where the API will stop generating further tokens.
## @param stream Logical. If set, partial message deltas will be sent, like in ChatGPT. Tokens will be sent as data-only server-sent events as they become available, with the stream terminated by a data.
## @param stream_options List. Options for streaming response. Only set this when you set stream: true.
#' @param temperature Numeric. What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.
#' @param top_p Numeric. An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.
#' @param tools List. A list of tools the model may call. Currently, only functions are supported as a tool. Use this to provide a list of functions the model may generate JSON inputs for. A max of 128 functions are supported.
#' @param tools_choice Character. Controls which (if any) tool is called by the model. "none" means the model will not call any tool and instead generates a message. "auto" means the model can pick between generating a message or calling one or more tools. "required" means the model must call one or more tools. Specifying a particular tool via `list(type = "function", function = list(name = "my_function"))` forces the model to call that tool. "none" is the default when no tools are present. "auto" is the default if tools are present.
#' @param parallel_tool_calls Logical. Whether to enable parallel function calling during tool use.
#' @param user Character. A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
#' @inheritParams common_parameters
#' @return A ChatCompletion R6 object.
#' @details Only chat completions that have been created with the store parameter set to true will be returned.
#' @name chat_completion_api
NULL

#' @description * `oai_create_chat_completion()`: Create a chat completion.`
#' @export
#' @rdname chat_completion_api
oai_create_chat_completion <- function(messages,
                                       model,
                                       frequency_penalty = NULL,
                                       logit_bias = NULL,
                                       logprobs = NULL,
                                       top_logprobs = NULL,
                                       max_tokens = NULL,
                                       n = NULL,
                                       presence_penalty = NULL,
                                       response_format = NULL,
                                       seed = NULL,
                                       service_tier = NULL,
                                       stop = NULL,
                                       stream = NULL,
                                       ## stream_options = NULL,
                                       temperature = NULL,
                                       top_p = NULL,
                                       tools = NULL,
                                       tools_choice = NULL,
                                       parallel_tool_calls = NULL,
                                       user = NULL,
                                       .classify_response = TRUE
                                       ) {
  if (inherits(messages, "oai_message")) {
    messages <- list(messages)
  } else if (is.character(messages)) {
    messages <- list(oai_message(messages))
  }
  body <- as.list(environment()) |> compact()
  oai_query(
    ep = c("chat", "completions"),
    method = "POST",
    body = body,
    .classify_response = .classify_response
  )
}


#' @description * `oai_get_chat_completion()`: Get a stored chat completion.
#' @param completion_id The ID of the chat completion to retrieve.
#' @export
#' @rdname chat_completion_api
oai_get_chat_completion <- function(completion_id, .classify_response = TRUE) {
  oai_query(
    ep = c("chat", "completions", completion_id),
    method = "GET",
    .classify_response = .classify_response
  )
}

#' @description * `oai_get_chat_messages()`: Get the messages in a stored chat completion.
#' @param completion_id The ID of the chat completion to retrieve messages from.
#' @param after Identifier for the last message from the previous pagination request.
#' @param limit Number of messages to retrieve.
#' @param order Sort order for messages by timestamp. Use asc for ascending order or desc for descending order. Defaults to asc.
#' @return `oai_get_chat_messages()` returns a list of messages in the chat completion.
#' @export
#' @rdname chat_completion_api
oai_get_chat_messages <- function(completion_id, after = NULL, limit = NULL, order = NULL) {
  oai_query(
    ep = c("chat", "completions", completion_id, "messages"),
    method = "GET",
    query = list(
      after = after,
      limit = limit,
      order = order
    ) |> compact()
  )
}


#' @description * `oai_list_chat_completions()`: List stored chat completions.
#' @param model The model used to generate the chat completions.
#' @param after Identifier for the last chat completion from the previous pagination request.
#' @param limit Number of chat completions to retrieve.
#' @param order Sort order for chat completions by timestamp. Use asc for ascending order or desc for descending order. Defaults to asc.
#' @return `oai_list_chat_completions()` returns a list of ChatCompletion objects.
#' @export
#' @rdname chat_completion_api
oai_list_chat_completions <- function(model = NULL, metadata = NULL, after = NULL, limit = NULL, order = NULL) {
  oai_query(
    ep = c("chat", "completions"),
    method = "GET",
    query = list(
      model = model,
      metadata = metadata,
      after = after,
      limit = limit,
      order = order
    ) |> compact()
  )
}

#' @description * `oai_update_chat_completion()`: Update a stored chat completion.
#' @param completion_id The ID of the chat completion to update.
#' @export
#' @rdname chat_completion_api
oai_update_chat_completion <- function(completion_id, metadata, .classify_response = TRUE) {
  oai_query(
    ep = c("chat", "completions", completion_id),
    method = "PATCH",
    body = list(metadata = metadata),
    .classify_response = .classify_response
  )
}

#' @description * `oai_delete_chat_completion()`: Delete a stored chat completion. Only chat completions that have been created with the store parameter set to true can be deleted.
#' @param completion_id The ID of the chat completion to delete.
#' @return `oai_delete_chat_completion()` returns a deletion confirmation object.
#' @export
#' @rdname chat_completion_api
oai_delete_chat_completion <- function(completion_id) {
  oai_query(
    ep = c("chat", "completions", completion_id),
    method = "DELETE"
  )
}


#' ChatCompletion R6 class
#'
#' @param completion_id A unique identifier for the chat completion.
#' @param messages A list of messages comprising the conversation so far.
#' @param ... Additional parameters passed to API functions
ChatCompletion <- R6Class(
  "ChatCompletion",
  portable = FALSE,
  public = list(
    #' @description Initialize a ChatCompletion object.
    #' @param resp A response object.
    initialize = function(completion_id = NULL, messages = NULL, ..., resp = NULL) {
      if (!is.null(completion_id)) {
        id <<- completion_id
        self$get()
      } else if (!is.null(messages)) {
        args <- list(messages = messages, ...)
        args$.classify_response <- FALSE
        do.call(oai_create_chat_completion, args)
      } else if (!is.null(resp)) {
        id <<- resp$id
        choices <<- resp$choices
        created <<- resp$created |> as_time()
        model <<- resp$model
        service_tier <<- resp$service_tier
        system_fingerprint <<- resp$system_fingerprint
        usage <<- resp$usage
      }
    },
    #' @field id A unique identifier for the chat completion.
    id = NULL,
    #' @field choices A list of chat completion choices. Can be more than one if n is greater than 1.
    choices = NULL,
    #' @field created The Unix timestamp (in seconds) of when the chat completion was created.
    created = NULL,
    #' @field model The model used for the chat completion.
    model = NULL,
    #' @field service_tier The service tier used for processing the request.
    service_tier = NULL,
    #' @field system_fingerprint This fingerprint represents the backend configuration that the model runs with.
    system_fingerprint = NULL,
    #' @field usage Usage statistics for the completion request.
    usage = NULL,
    #' @description Get the chat completion object.
    get = function() {
      oai_get_chat_completion(
        completion_id = self$id, .classify_response = FALSE
      ) |>
        initialize(resp = _)
      self
    },
    #' @description Update the chat completion object.
    #' @param metadata List of key-value pairs.
    update = function(metadata) {
      oai_update_chat_completion(
        completion_id = self$id,
        metadata = metadata,
        .classify_response = FALSE
      ) |>
        initialize(resp = _)
      self
    },
    #' @description Delete the chat completion object.
    delete = function() {
      oai_delete_chat_completion(completion_id = self$id)
    },
    #' @description Get the messages in the chat completion.
    get_messages = function(...) {
      oai_get_chat_messages(...)
    },
    #' @description Get the messages in the chat completion.
    content_text = function() {
      self$choices[[1]]$message$content
    }
  )
)

