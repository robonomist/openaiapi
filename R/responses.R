#' Responses API
#'
#' @description * `oai_create_model_response()` - Create a model response.
#' @param input Character or List. Text, image, or file inputs to the model, used to generate a response.
#' @param model Character. Model ID used to generate the response, like "gpt-4o" or "o1".
#' @param include List. Specify additional output data to include in the model response.
#' @param instructions Character. Inserts a system (or developer) message as the first item in the model's context.
#' @param max_output_tokens Integer. An upper bound for the number of tokens that can be generated for a response, including visible output tokens and reasoning tokens.
#' @param parallel_tool_calls Logical. Whether to allow the model to run tool calls in parallel.
#' @param previous_response_id Character. The unique ID of the previous response to the model. Use this to create multi-turn conversations.
#' @param reasoning List. Configuration options for reasoning models.
#' @param store Logical. Whether to store the generated model response for later retrieval via API.
#' @param stream Logical. If set to true, the function will return a `ModelResponseStream` object.
#' @param temperature Numeric. What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.
#' @param text List. Configuration options for a text response from the model. Can be plain text or structured JSON data.
#' @param tool_choice Character or List. How the model should select which tool (or tools) to use when generating a response.
#' @param tools List. An array of tools the model may call while generating a response.
#' @param top_p Numeric. An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass.
#' @param truncation Character. The truncation strategy to use for the model response.
#' @param user Character. A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
#' @inheritParams common_parameters
#' @return * `oai_create_model_response()` - A `ModelResponse` object.
#' @export
#' @rdname model_response
oai_create_model_response <- function(input,
                                      model = "gpt-4o",
                                      include = NULL,
                                      instructions = NULL,
                                      max_output_tokens = NULL,
                                      parallel_tool_calls = NULL,
                                      previous_response_id = NULL,
                                      reasoning = NULL,
                                      store = NULL,
                                      stream = NULL,
                                      temperature = NULL,
                                      text = NULL,
                                      tool_choice = NULL,
                                      tools = NULL,
                                      top_p = NULL,
                                      truncation = NULL,
                                      user = NULL,
                                      .classify_response = TRUE,
                                      .async = FALSE) {
  # Validate input
  if (missing(input)) {
    stop("The 'input' parameter is required.")
  }
  # Create request body
  body <- list(
    input = input,
    model = model,
    include = include,
    instructions = instructions,
    max_output_tokens = max_output_tokens,
    parallel_tool_calls = parallel_tool_calls,
    previous_response_id = previous_response_id,
    reasoning = reasoning,
    store = store,
    stream = stream,
    temperature = temperature,
    text = text,
    tool_choice = tool_choice,
    tools = tools,
    top_p = top_p,
    truncation = truncation,
    user = user
  )
  oai_query(
    ep = "responses",
    method = "POST",
    body = body,
    .classify_response = .classify_response,
    .async = .async,
    .stream_class = "ModelResponse"
  )
}

#' @description * `oai_get_model_response()` - Retrieve a model response.
#' @param response_id Character. The ID of the response to retrieve.
#' @return * `oai_get_model_response()` - A `ModelResponse` object.
#' @export
#' @rdname model_response
oai_get_model_response <- function(response_id,
                                   include = NULL,
                                   .classify_response = TRUE,
                                   .async = FALSE) {
  if (missing(response_id)) {
    stop("The 'response_id' parameter is required.")
  }
  body <- list(
    include = include
  )
  oai_query(
    ep = c("responses", response_id),
    method = "GET",
    body = body,
    .classify_response = .classify_response,
    .async = .async
  )
}


#' @description * `oai_delete_model_response()` - Delete a model response.
#' @rdname model_response
#' @export
oai_delete_model_response <- function(response_id,
                                      .classify_response = TRUE,
                                      .async = FALSE) {
  if (missing(response_id)) {
    stop("The 'response_id' parameter is required.")
  }
  oai_query(
    ep = c("responses", response_id),
    method = "DELETE",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_list_items()` - List input items for a model response.
#' @param response_id Character. The ID of the response to retrieve input items for.
#' @rdname model_response
oai_list_items <- function(response_id,
                           after = NULL,
                           before = NULL,
                           include = NULL,
                           limit = NULL,
                           order = NULL,
                           .classify_response = TRUE,
                           .async = FALSE) {
  if (missing(response_id)) {
    stop("The 'response_id' parameter is required.")
  }
  body <- list(
    after = after,
    before = before,
    include = include,
    limit = limit,
    order = order
  )
  oai_query(
    ep = c("responses", response_id, "input_items"),
    method = "GET",
    body = body,
    .classify_response = .classify_response,
    .async = .async
  )
}

#' ModelResponse R6 Class
#' @description The `ModelResponse` class represents a model response object in the OpenAI API.
#' @param response_id Character. Unique identifier for this Response.
#' @param input Character or List. Text, image, or file inputs to the model, used to generate a response.
#' @param ... Additional parameters to pass to the model.
#' @param resp List. The response object returned by the OpenAI API.
#' @param .async Logical. Whether to retrieve the response asynchronously.
#' @export
ModelResponse <- R6Class(
  "ModelResponse",
  inherit = Utils,
  portable = FALSE,
  private = list(
    schema = list(
      as_is = c("error", "id", "incomplete_details", "instructions", "model", "output", "output_text", "parallel_tool_calls", "previous_response_id", "reasoning", "status", "temperature", "text", "tool_choice", "tools", "top_p", "truncation", "usage", "user"),
      as_time = c("created_at")
    )
  ),
  public = list(
    #' @description Initialize a `ModelResponse` object.
    initialize = function(response_id = NULL,
                          input = NULL,
                          ...,
                          resp = NULL,
                          .async = TRUE) {
      if (!is.null(resp)) {
        store_response(resp)
      } else if (!is.null(response_id)) {
        id <<- response_id
        .async <<- .async
        self$get()
      } else if (!is.null(input)) {
        args <- list(input = input, ...)
        args$.classify_response <- FALSE
        do.call(oai_create_model_response, args) |>
          store_response()
      } else {
        stop("Either 'response_id' or 'input' must be provided.")
      }
    },
    #' @field id Character. Unique identifier for this Response.
    id = NULL,
    #' @field created_at Numeric. Unix timestamp (in seconds) of when this Response was created.
    created_at = NULL,
    #' @field error List or NULL. An error object returned when the model fails to generate a Response.
    error = NULL,
    #' @field incomplete_details List or NULL. Details about why the response is incomplete.
    incomplete_details = NULL,
    #' @field instructions Character or NULL. Inserts a system (or developer) message as the first item in the model's context.
    instructions = NULL,
    #' @field max_output_tokens Integer or NULL. An upper bound for the number of tokens that can be generated for a response, including visible output tokens and reasoning tokens.
    max_output_tokens = NULL,
    #' @field metadata List. Set of 16 key-value pairs that can be attached to an object.
    metadata = NULL,
    #' @field model Character. Model ID used to generate the response, like gpt-4o or o1.
    model = NULL,
    #' @field output List. An array of content items generated by the model.
    output = NULL,
    #' @field output_text Character or NULL. SDK-only convenience property that contains the aggregated text output from all output_text items in the output array, if any are present.
    output_text = NULL,
    #' @field parallel_tool_calls Logical. Whether to allow the model to run tool calls in parallel.
    parallel_tool_calls = NULL,
    #' @field previous_response_id Character or NULL. The unique ID of the previous response to the model.
    previous_response_id = NULL,
    #' @field reasoning List or NULL. Configuration options for reasoning models.
    reasoning = NULL,
    #' @field status Character. The status of the response generation.
    status = NULL,
    #' @field temperature Numeric or NULL. What sampling temperature to use, between 0 and 2.
    temperature = NULL,
    #' @field text List. Configuration options for a text response from the model.
    text = NULL,
    #' @field tool_choice Character or List. How the model should select which tool (or tools) to use when generating a response.
    tool_choice = NULL,
    #' @field tools List. An array of tools the model may call while generating a response.
    tools = NULL,
    #' @field top_p Numeric or NULL. An alternative to sampling with temperature, called nucleus sampling.
    top_p = NULL,
    #' @field truncation Character or NULL. The truncation strategy to use for the model response.
    truncation = NULL,
    #' @field usage List. Represents token usage details including input tokens, output tokens, a breakdown of output tokens, and the total tokens used.
    usage = NULL,
    #' @field user Character. A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
    user = NULL,
    #' @description Get a fresh copy of the model response.
    get = function() {
      oai_get_model_response(
        response_id = id,
        .classify_response = FALSE,
        .async = .async
      ) |>
        store_response()
    }
  )
)

ModelResponseStream <- R6Class(
  "ModelResponseStream",
  inherit = ModelResponse,
  portable = FALSE,
  public = list(
    initialize = function(stream_reader) {
      stream_reader <<- stream_reader
      .async <<- stream_reader$async
    },
    stream_async = function(on_event = function(event) {},
                            env = parent.frame()) {
      stream_reader$stream_async(
        handle_event = function(event) {
          cat("Event received:", event$type, "\n")
          event$type |> switch(
            "response.created" = ,
            "response.in_progress" = ,
            "response.completed" = ,
            "response.failed" = ,
            "response.incomplete" = {
              store_response(event$data$response)
            },
            "response.output_item.added" = ,
            "response.output_item.done" = {
              output_index <- event$data$output_index + 1L
              output[[output_index]] <<- event$data$item
            },
            "response.content_part.added" = ,
            "response.content_part.done" = {
              output_index <- event$data$output_index + 1L
              content_index <- event$data$content_index + 1L
              ## item_id <- event$data$item_id
              output[[output_index]]$content[[content_index]] <<- event$data$part
            },
            "response.output_text.delta" = {
              output_index <- event$data$output_index + 1L
              content_index <- event$data$content_index + 1L
              output[[output_index]]$content[[content_index]]$text <<- paste0(
                output[[output_index]]$content[[content_index]]$text,
                event$data$delta
              )
            },
            "response.output_text.annotation.added" = {
              output_index <- event$data$output_index + 1L
              content_index <- event$data$content_index + 1L
              annotation_index <- event$data$annotation_index + 1L
              output[[output_index]]$content[[content_index]]$annotations[[annotation_index]] <<- event$data$annotation
            },
            "response.output_text.done" = {
              output_index <- event$data$output_index + 1L
              content_index <- event$data$content_index + 1L
              output[[output_index]]$content[[content_index]]$text <<- event$data$text
            },
            "response.refusal.delta" = {
              output_index <- event$data$output_index + 1L
              content_index <- event$data$content_index + 1L
              output[[output_index]]$content[[content_index]]$refusal <<- paste0(
                output[[output_index]]$content[[content_index]]$refusal,
                event$data$delta
              )
            },
            "response.refusal.done" = {
              output_index <- event$data$output_index + 1L
              content_index <- event$data$content_index + 1L
              output[[output_index]]$content[[content_index]]$refusal <<- event$data$refusal
            },
            "response.function_call_arguments.delta" = {
              output_index <- event$data$output_index + 1L
              output[[output_index]]$arguments <<- paste0(
                output[[output_index]]$arguments,
                event$data$delta
              )
            },
            "response.function_call_arguments.done" = {
              output_index <- event$data$output_index + 1L
              output[[output_index]]$arguments <<- event$data$arguments
            },
            "response.file_search_call.in_progress" = {
              output_index <- event$data$output_index + 1L
              event$data$status <- "in_progress"
              output[[output_index]] <<- event$data
            },
            "response.file_search_call.searching" = {
              output_index <- event$data$output_index + 1L
              event$data$status <- "searching"
              output[[output_index]] <<- event$data
            },
            "response.file_search_call.completed" = {
              output_index <- event$data$output_index + 1L
              event$data$status <- "completed"
              output[[output_index]] <<- event$data
            },
            "response.web_search_call.in_progress" = {
              output_index <- event$data$output_index + 1L
              event$data$status <- "in_progress"
              output[[output_index]] <<- event$data
            },
            "response.web_search_call.searching" ={
              output_index <- event$data$output_index + 1L
              event$data$status <- "searching"
              output[[output_index]] <<- event$data
            },
            "response.web_search_call.completed" = {
              output_index <- event$data$output_index + 1L
              event$data$status <- "completed"
              output[[output_index]] <<- event$data
            },
            "error" = {
              cli_abort(
                c("x" = "Error {event$data$code}: {event$data$message}"),
                params = event$data$params
              )
            }
          )
          on_event(event)
        }
      )
    }
  ),
  private = list(
    stream_reader = NULL
  )
)



## response.created

## An event that is emitted when a response is created.
## response

## object

## The response that was created.
## type

## string

## The type of the event. Always response.created.
## OBJECT response.created

## {
##   "type": "response.created",
##   "response": {
##     "id": "resp_67ccfcdd16748190a91872c75d38539e09e4d4aac714747c",
##     "object": "response",
##     "created_at": 1741487325,
##     "status": "in_progress",
##     "error": null,
##     "incomplete_details": null,
##     "instructions": null,
##     "max_output_tokens": null,
##     "model": "gpt-4o-2024-08-06",
##     "output": [],
##     "parallel_tool_calls": true,
##     "previous_response_id": null,
##     "reasoning": {
##       "effort": null,
##       "generate_summary": null
##     },
##     "store": true,
##     "temperature": 1,
##     "text": {
##       "format": {
##         "type": "text"
##       }
##     },
##     "tool_choice": "auto",
##     "tools": [],
##     "top_p": 1,
##     "truncation": "disabled",
##     "usage": null,
##     "user": null,
##     "metadata": {}
##   }
## }

## response.in_progress

## Emitted when the response is in progress.
## response

## object

## The response that is in progress.
## type

## string

## The type of the event. Always response.in_progress.
## OBJECT response.in_progress

## {
##   "type": "response.in_progress",
##   "response": {
##     "id": "resp_67ccfcdd16748190a91872c75d38539e09e4d4aac714747c",
##     "object": "response",
##     "created_at": 1741487325,
##     "status": "in_progress",
##     "error": null,
##     "incomplete_details": null,
##     "instructions": null,
##     "max_output_tokens": null,
##     "model": "gpt-4o-2024-08-06",
##     "output": [],
##     "parallel_tool_calls": true,
##     "previous_response_id": null,
##     "reasoning": {
##       "effort": null,
##       "generate_summary": null
##     },
##     "store": true,
##     "temperature": 1,
##     "text": {
##       "format": {
##         "type": "text"
##       }
##     },
##     "tool_choice": "auto",
##     "tools": [],
##     "top_p": 1,
##     "truncation": "disabled",
##     "usage": null,
##     "user": null,
##     "metadata": {}
##   }
## }

## response.completed

## Emitted when the model response is complete.
## response

## object

## Properties of the completed response.
## type

## string

## The type of the event. Always response.completed.
## OBJECT response.completed

## {
##   "type": "response.completed",
##   "response": {
##     "id": "resp_123",
##     "object": "response",
##     "created_at": 1740855869,
##     "status": "completed",
##     "error": null,
##     "incomplete_details": null,
##     "input": [],
##     "instructions": null,
##     "max_output_tokens": null,
##     "model": "gpt-4o-mini-2024-07-18",
##     "output": [
##       {
##         "id": "msg_123",
##         "type": "message",
##         "role": "assistant",
##         "content": [
##           {
##             "type": "output_text",
##             "text": "In a shimmering forest under a sky full of stars, a lonely unicorn named Lila discovered a hidden pond that glowed with moonlight. Every night, she would leave sparkling, magical flowers by the water's edge, hoping to share her beauty with others. One enchanting evening, she woke to find a group of friendly animals gathered around, eager to be friends and share in her magic.",
##             "annotations": []
##           }
##         ]
##       }
##     ],
##     "previous_response_id": null,
##     "reasoning_effort": null,
##     "store": false,
##     "temperature": 1,
##     "text": {
##       "format": {
##         "type": "text"
##       }
##     },
##     "tool_choice": "auto",
##     "tools": [],
##     "top_p": 1,
##     "truncation": "disabled",
##     "usage": {
##       "input_tokens": 0,
##       "output_tokens": 0,
##       "output_tokens_details": {
##         "reasoning_tokens": 0
##       },
##       "total_tokens": 0
##     },
##     "user": null,
##     "metadata": {}
##   }
## }

## response.failed

## An event that is emitted when a response fails.
## response

## object

## The response that failed.
## type

## string

## The type of the event. Always response.failed.
## OBJECT response.failed

## {
##   "type": "response.failed",
##   "response": {
##     "id": "resp_123",
##     "object": "response",
##     "created_at": 1740855869,
##     "status": "failed",
##     "error": {
##       "code": "server_error",
##       "message": "The model failed to generate a response."
##     },
##     "incomplete_details": null,
##     "instructions": null,
##     "max_output_tokens": null,
##     "model": "gpt-4o-mini-2024-07-18",
##     "output": [],
##     "previous_response_id": null,
##     "reasoning_effort": null,
##     "store": false,
##     "temperature": 1,
##     "text": {
##       "format": {
##         "type": "text"
##       }
##     },
##     "tool_choice": "auto",
##     "tools": [],
##     "top_p": 1,
##     "truncation": "disabled",
##     "usage": null,
##     "user": null,
##     "metadata": {}
##   }
## }

## response.incomplete

## An event that is emitted when a response finishes as incomplete.
## response

## object

## The response that was incomplete.
## type

## string

## The type of the event. Always response.incomplete.
## OBJECT response.incomplete

## {
##   "type": "response.incomplete",
##   "response": {
##     "id": "resp_123",
##     "object": "response",
##     "created_at": 1740855869,
##     "status": "incomplete",
##     "error": null, 
##     "incomplete_details": {
##       "reason": "max_tokens"
##     },
##     "instructions": null,
##     "max_output_tokens": null,
##     "model": "gpt-4o-mini-2024-07-18",
##     "output": [],
##     "previous_response_id": null,
##     "reasoning_effort": null,
##     "store": false,
##     "temperature": 1,
##     "text": {
##       "format": {
##         "type": "text"
##       }
##     },
##     "tool_choice": "auto",
##     "tools": [],
##     "top_p": 1,
##     "truncation": "disabled",
##     "usage": null,
##     "user": null,
##     "metadata": {}
##   }
## }

## response.output_item.added

## Emitted when a new output item is added.
## item

## object

## The output item that was added.
## output_index

## integer

## The index of the output item that was added.
## type

## string

## The type of the event. Always response.output_item.added.
## OBJECT response.output_item.added

## {
##   "type": "response.output_item.added",
##   "output_index": 0,
##   "item": {
##     "id": "msg_123",
##     "status": "in_progress",
##     "type": "message",
##     "role": "assistant",
##     "content": []
##   }
## }

## response.output_item.done

## Emitted when an output item is marked done.
## item

## object

## The output item that was marked done.
## output_index

## integer

## The index of the output item that was marked done.
## type

## string

## The type of the event. Always response.output_item.done.
## OBJECT response.output_item.done

## {
##   "type": "response.output_item.done",
##   "output_index": 0,
##   "item": {
##     "id": "msg_123",
##     "status": "completed",
##     "type": "message",
##     "role": "assistant",
##     "content": [
##       {
##         "type": "output_text",
##         "text": "In a shimmering forest under a sky full of stars, a lonely unicorn named Lila discovered a hidden pond that glowed with moonlight. Every night, she would leave sparkling, magical flowers by the water's edge, hoping to share her beauty with others. One enchanting evening, she woke to find a group of friendly animals gathered around, eager to be friends and share in her magic.",
##         "annotations": []
##       }
##     ]
##   }
## }

## response.content_part.added

## Emitted when a new content part is added.
## content_index

## integer

## The index of the content part that was added.
## item_id

## string

## The ID of the output item that the content part was added to.
## output_index

## integer

## The index of the output item that the content part was added to.
## part

## object

## The content part that was added.
## type

## string

## The type of the event. Always response.content_part.added.
## OBJECT response.content_part.added

## {
##   "type": "response.content_part.added",
##   "item_id": "msg_123",
##   "output_index": 0,
##   "content_index": 0,
##   "part": {
##     "type": "output_text",
##     "text": "",
##     "annotations": []
##   }
## }

## response.content_part.done

## Emitted when a content part is done.
## content_index

## integer

## The index of the content part that is done.
## item_id

## string

## The ID of the output item that the content part was added to.
## output_index

## integer

## The index of the output item that the content part was added to.
## part

## object

## The content part that is done.
## type

## string

## The type of the event. Always response.content_part.done.
## OBJECT response.content_part.done

## {
##   "type": "response.content_part.done",
##   "item_id": "msg_123",
##   "output_index": 0,
##   "content_index": 0,
##   "part": {
##     "type": "output_text",
##     "text": "In a shimmering forest under a sky full of stars, a lonely unicorn named Lila discovered a hidden pond that glowed with moonlight. Every night, she would leave sparkling, magical flowers by the water's edge, hoping to share her beauty with others. One enchanting evening, she woke to find a group of friendly animals gathered around, eager to be friends and share in her magic.",
##     "annotations": []
##   }
## }

## response.output_text.delta

## Emitted when there is an additional text delta.
## content_index

## integer

## The index of the content part that the text delta was added to.
## delta

## string

## The text delta that was added.
## item_id

## string

## The ID of the output item that the text delta was added to.
## output_index

## integer

## The index of the output item that the text delta was added to.
## type

## string

## The type of the event. Always response.output_text.delta.
## OBJECT response.output_text.delta

## {
##   "type": "response.output_text.delta",
##   "item_id": "msg_123",
##   "output_index": 0,
##   "content_index": 0,
##   "delta": "In"
## }

## response.output_text.annotation.added

## Emitted when a text annotation is added.
## annotation

## object
## annotation_index

## integer

## The index of the annotation that was added.
## content_index

## integer

## The index of the content part that the text annotation was added to.
## item_id

## string

## The ID of the output item that the text annotation was added to.
## output_index

## integer

## The index of the output item that the text annotation was added to.
## type

## string

## The type of the event. Always response.output_text.annotation.added.
## OBJECT response.output_text.annotation.added

## {
##   "type": "response.output_text.annotation.added",
##   "item_id": "msg_abc123",
##   "output_index": 1,
##   "content_index": 0,
##   "annotation_index": 0,
##   "annotation": {
##     "type": "file_citation",
##     "index": 390,
##     "file_id": "file-4wDz5b167pAf72nx1h9eiN",
##     "filename": "dragons.pdf"
##   }
## }

## response.output_text.done

## Emitted when text content is finalized.
## content_index

## integer

## The index of the content part that the text content is finalized.
## item_id

## string

## The ID of the output item that the text content is finalized.
## output_index

## integer

## The index of the output item that the text content is finalized.
## text

## string

## The text content that is finalized.
## type

## string

## The type of the event. Always response.output_text.done.
## OBJECT response.output_text.done

## {
##   "type": "response.output_text.done",
##   "item_id": "msg_123",
##   "output_index": 0,
##   "content_index": 0,
##   "text": "In a shimmering forest under a sky full of stars, a lonely unicorn named Lila discovered a hidden pond that glowed with moonlight. Every night, she would leave sparkling, magical flowers by the water's edge, hoping to share her beauty with others. One enchanting evening, she woke to find a group of friendly animals gathered around, eager to be friends and share in her magic."
## }

## response.refusal.delta

## Emitted when there is a partial refusal text.
## content_index

## integer

## The index of the content part that the refusal text is added to.
## delta

## string

## The refusal text that is added.
## item_id

## string

## The ID of the output item that the refusal text is added to.
## output_index

## integer

## The index of the output item that the refusal text is added to.
## type

## string

## The type of the event. Always response.refusal.delta.
## OBJECT response.refusal.delta

## {
##   "type": "response.refusal.delta",
##   "item_id": "msg_123",
##   "output_index": 0,
##   "content_index": 0,
##   "delta": "refusal text so far"
## }

## response.refusal.done

## Emitted when refusal text is finalized.
## content_index

## integer

## The index of the content part that the refusal text is finalized.
## item_id

## string

## The ID of the output item that the refusal text is finalized.
## output_index

## integer

## The index of the output item that the refusal text is finalized.
## refusal

## string

## The refusal text that is finalized.
## type

## string

## The type of the event. Always response.refusal.done.
## OBJECT response.refusal.done

## {
##   "type": "response.refusal.done",
##   "item_id": "item-abc",
##   "output_index": 1,
##   "content_index": 2,
##   "refusal": "final refusal text"
## }

## response.function_call_arguments.delta

## Emitted when there is a partial function-call arguments delta.
## delta

## string

## The function-call arguments delta that is added.
## item_id

## string

## The ID of the output item that the function-call arguments delta is added to.
## output_index

## integer

## The index of the output item that the function-call arguments delta is added to.
## type

## string

## The type of the event. Always response.function_call_arguments.delta.
## OBJECT response.function_call_arguments.delta

## {
##   "type": "response.function_call_arguments.delta",
##   "item_id": "item-abc",
##   "output_index": 0,
##   "delta": "{ \"arg\":"
## }

## response.function_call_arguments.done

## Emitted when function-call arguments are finalized.
## arguments

## string

## The function-call arguments.
## item_id

## string

## The ID of the item.
## output_index

## integer

## The index of the output item.
## type

## string
## OBJECT response.function_call_arguments.done

## {
##   "type": "response.function_call_arguments.done",
##   "item_id": "item-abc",
##   "output_index": 1,
##   "arguments": "{ \"arg\": 123 }"
## }

## response.file_search_call.in_progress

## Emitted when a file search call is initiated.
## item_id

## string

## The ID of the output item that the file search call is initiated.
## output_index

## integer

## The index of the output item that the file search call is initiated.
## type

## string

## The type of the event. Always response.file_search_call.in_progress.
## OBJECT response.file_search_call.in_progress

## {
##   "type": "response.file_search_call.in_progress",
##   "output_index": 0,
##   "item_id": "fs_123",
## }

## response.file_search_call.searching

## Emitted when a file search is currently searching.
## item_id

## string

## The ID of the output item that the file search call is initiated.
## output_index

## integer

## The index of the output item that the file search call is searching.
## type

## string

## The type of the event. Always response.file_search_call.searching.
## OBJECT response.file_search_call.searching

## {
##   "type": "response.file_search_call.searching",
##   "output_index": 0,
##   "item_id": "fs_123",
## }

## response.file_search_call.completed

## Emitted when a file search call is completed (results found).
## item_id

## string

## The ID of the output item that the file search call is initiated.
## output_index

## integer

## The index of the output item that the file search call is initiated.
## type

## string

## The type of the event. Always response.file_search_call.completed.
## OBJECT response.file_search_call.completed

## {
##   "type": "response.file_search_call.completed",
##   "output_index": 0,
##   "item_id": "fs_123",
## }

## response.web_search_call.in_progress

## Emitted when a web search call is initiated.
## item_id

## string

## Unique ID for the output item associated with the web search call.
## output_index

## integer

## The index of the output item that the web search call is associated with.
## type

## string

## The type of the event. Always response.web_search_call.in_progress.
## OBJECT response.web_search_call.in_progress

## {
##   "type": "response.web_search_call.in_progress",
##   "output_index": 0,
##   "item_id": "ws_123",
## }

## response.web_search_call.searching

## Emitted when a web search call is executing.
## item_id

## string

## Unique ID for the output item associated with the web search call.
## output_index

## integer

## The index of the output item that the web search call is associated with.
## type

## string

## The type of the event. Always response.web_search_call.searching.
## OBJECT response.web_search_call.searching

## {
##   "type": "response.web_search_call.searching",
##   "output_index": 0,
##   "item_id": "ws_123",
## }

## response.web_search_call.completed

## Emitted when a web search call is completed.
## item_id

## string

## Unique ID for the output item associated with the web search call.
## output_index

## integer

## The index of the output item that the web search call is associated with.
## type

## string

## The type of the event. Always response.web_search_call.completed.
## OBJECT response.web_search_call.completed

## {
##   "type": "response.web_search_call.completed",
##   "output_index": 0,
##   "item_id": "ws_123",
## }

## error

## Emitted when an error occurs.
## code

## string or null

## The error code.
## message

## string
## param

## string or null

## The error parameter.
## type

## string

## The type of th

## e event. Always error.
## OBJECT error

## {
##   "type": "error",
##   "code": "ERR_SOMETHING",
##   "message": "Something went wrong",
##   "param": null
## }

