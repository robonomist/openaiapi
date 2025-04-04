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
  if (!is.null(tools)) {
    if (inherits(tools, "oai_function_tool")) {
      tools <- list(tools)
    }
    ## Cast legacy tools for responses API
    tools <- lapply(tools, function(tool) {
      if (inherits(tool, "oai_function_tool")) {
        tool <- tool$`function`
        tool$type <- "function"
      }
      tool
    })
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
    },
    do_tool_calls = function(env = parent.frame()) {
      tool_outputs <- NULL
      for (i in seq_along(output)) {
        if (output[[i]]$type == "function_call") {
          function_call <- output[[i]]
          args <- fromJSON(
            function_call$arguments,
            simplifyVector = getOption("openaiapi.tool_call_simplifyVector", TRUE)
          )
          what <- function_call$name
          result <- do.call(what, args, envir = env)
          tool_outputs[[length(tool_outputs) + 1L]] <- list(
            type = "function_call_output",
            call_id = function_call$call_id,
            output = result
          )
        }
      }
      oai_create_model_response(
        input = tool_outputs,
        instructions = instructions,
        tools = tools,
        max_output_tokens = max_output_tokens,
        previous_response_id = id,
        reasoning = reasoning,
        temperature = temperature,
        top_p = top_p,
        truncation = truncation,
        user = user,
        .classify_response = FALSE
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
    stream = function(on_event = function(event) {},
                      on_output_text_delta = function(data) {},
                      env = parent.frame()) {
      fun <- function(event) {
        handle_event(event, on_event, on_output_text_delta)
      }
      if (.async) {
        stream_reader$stream_async(handle_event = fun) |>
          then(function(...) {
            self
          })
      } else {
        stream_reader$stream_sync(handle_event = fun)
        invisible(self)
      }
    }
  ),
  private = list(
    stream_reader = NULL,
    handle_event = function(event, on_event, on_output_text_delta) {
      ## cat("Event received:", event$type, "\n")
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
          output[[output_index]]$content[[content_index]] <<- event$data$part
        },
        "response.output_text.delta" = {
          output_index <- event$data$output_index + 1L
          content_index <- event$data$content_index + 1L
          output[[output_index]]$content[[content_index]]$text <<- paste0(
            output[[output_index]]$content[[content_index]]$text,
            event$data$delta
          )
          on_output_text_delta(event$data)
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
          ## on_refusal_delta(event$data)
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
          ## on_function_call_arguments_delta(event$data)
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
        "response.web_search_call.searching" = {
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
)

