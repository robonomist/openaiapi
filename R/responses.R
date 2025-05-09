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
#' @param stream Logical. If set to `TRUE`, the function will return a `ModelResponseStream` object.
#' @param temperature Numeric. What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.
#' @param text List. Configuration options for a text response from the model. Can be plain text or structured JSON data.
#' @param tool_choice Character or List. How the model should select which tool (or tools) to use when generating a response.
#' @param tools List. An array of tools the model may call while generating a response.
#' @param top_p Numeric. An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass.
#' @param truncation Character. The truncation strategy to use for the model response.
#' @param user Character. A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
#' @param .perform_query Logical. Set to `FALSE` to skip the API call and return a ModelResponse or ModelResponseStream object, which can be used to call the API later.
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
                                      .async = FALSE,
                                      .perform_query = TRUE) {
  # Validate input
  if (!.perform_query) {
    input <- NULL
  } else if (missing(input)) {
    stop("The 'input' parameter is required.")
  } else if (inherits(input, "oai_message")) {
    input <- list(input)
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
  if (.perform_query) {
    oai_query(
      ep = "responses",
      method = "POST",
      body = body,
      .classify_response = .classify_response,
      .async = .async,
      .stream_class = "ModelResponse"
    )
  } else {
    obj <-
      if (isTRUE(stream)) {
        ModelResponseStream$new(init = body)
      } else {
        ModelResponse$new(resp = body)
      }
    obj$.async <- .async
    obj
  }
}


#' @description * `oai_model_response()` - Create a ModelResponse or ModelResponseStream object without making an API call.
#' @return * `oai_model_response()` - A `ModelResponse` or `ModelResponseStream` object.
#' @rdname model_response
#' @export
oai_model_response <- function(model = "gpt-4o",
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
                               .async = FALSE) {
  args <- as.list(environment(), all.names = TRUE)
  args$.perform_query <- FALSE
  do.call(oai_create_model_response, args)
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
#' @export
#' @rdname model_response
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

#' @description * `oai_list_input_items()` - List input items for a model response.
#' @param response_id Character. The ID of the response to retrieve input items for.
#' @export
#' @rdname model_response
oai_list_input_items <- function(response_id,
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
  oai_query_list(
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
#' @param env Environment. The environment in which to evaluate the tool calls.
#' @export
ModelResponse <- R6Class(
  "ModelResponse",
  inherit = Utils,
  portable = FALSE,
  private = list(
    schema = list(
      as_is = c("error", "id", "incomplete_details", "instructions", "model", "output", "parallel_tool_calls", "previous_response_id", "reasoning", "tools", "status", "temperature", "text", "tool_choice", "top_p", "truncation", "usage", "user"),
      as_time = c("created_at")
    ),
    store_response = function(resp) {
      super$store_response(resp)
      if (!is.null(tools)) {
        ## HACK: Add empty properties to tools
        tools <<- lapply(tools, function(tool) {
          if (length(tool$parameters$properties) == 0L) {
            tool$parameters <-
              I(append(tool$parameters, list(properties = NULL)))
          }
          tool
        })
      }
      output_text <<- NULL
      if (!is.null(output)) {
        ## Set output_text if available
        for (i in output) {
          if (i$type == "message" && i$role == "assistant") {
            for (j in i$content) {
              if (j$type == "output_text") {
                output_text <<- paste0(
                  output_text %||% "",
                  j$text
                )
              }
            }
          }
        }
      }
    },
    .stream = NULL
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
    #' @description Store the model response.
    delete = function() {
      oai_delete_model_response(
        response_id = id,
        .classify_response = FALSE,
        .async = .async
      ) |>
        store_response()
    },
    #' @description List input items for the model response.
    #' @param ... Additional parameters to pass to the `oai_list_items()` function.
    list_input_items = function(...) {
      oai_list_input_items(
        response_id = id,
        ...,
        .classify_response = FALSE,
        .async = .async
      ) |>
        store_response()
    },
    #' @description Do all tool calls in the model response and return the results.
    do_tool_calls = function(env = parent.frame()) {
      if (is.null(env)) {
        return(NULL)
      }
      tool_calls <- lapply(output, function(x) {
        if (x$type == "function_call") x
      })
      tool_calls <- Filter(Negate(is.null), tool_calls)
      if (length(tool_calls) > 0L) {
        tool_calls |>
          lapply(function(x) {
            args <- fromJSON(
              x$arguments,
              simplifyVector = getOption("openaiapi.tool_call_simplifyVector", FALSE)
            )
            if (length(args) == 0L) {
              args <- list()
            }
            what <- x$name
            result <- tryCatch(
              do.call(what, args, envir = env),
              error = function(cnd) {
                cli_abort(
                  "do_tool_calls() failed to call `{what}:{cnd$message}`",
                  call = call("do_tool_calls")
                )
              }
            )
            list(
              type = "function_call_output",
              call_id = x$call_id,
              output = result
            )
          })
      }
    },
    #' @description Create a new model response based on the previous response.
    #' @param input Character or List. Text, image, or file inputs to the model, used to generate a response.
    #' @param stream Logical. Use to change the streaming mode of the response.
    respond = function(input, stream = NULL, ...) {
      args <- list(input = input, ...)
      defaults <- list(
        instructions = instructions,
        tools = if (!is.null(tools)) I(tools),
        max_output_tokens = max_output_tokens,
        previous_response_id = id,
        reasoning = reasoning,
        temperature = temperature,
        top_p = top_p,
        truncation = truncation,
        user = user,
        stream = stream %||% .stream,
        .async = .async,
        .classify_response = FALSE
      )
      args <- modifyList(defaults, args)
      do.call(oai_create_model_response, args) |>
        store_response()
    },
    #' @description Submit tool outputs to generate a new model response.
    #' @param tool_outputs List. The tool outputs to submit.
    submit_tool_outputs = function(tool_outputs) {
      if (length(tool_outputs) == 0L) {
        cli_abort("No tool outputs to submit.")
      }
      respond(tool_outputs)
    },
    #' @description Submit tool outputs to generate a new model response.
    wait = function(env = parent.frame()) {
      while (length(tool_outputs <- do_tool_calls(env))) {
        submit_tool_outputs(tool_outputs)
      }
      self
    },
    #' @description Wait for the model response to complete.
    await = function(env = parent.frame()) {
      env <- force(env)
      promise(function(resolve, reject) {
        handle_tool_calls <- function() {
          tool_outputs <- tryCatch(
            do_tool_calls(env),
            error = function(e) {
              reject(paste("Error in tool calls:", e$message))
            }
          )
          if (length(tool_outputs) > 0L) {
            tryCatch(
              submit_tool_outputs(tool_outputs),
              error = function(e) {
                reject(paste("Error in tool outputs:", e$message))
              }
            )
            handle_tool_calls()
          } else {
            resolve(self)
          }
        }
        handle_tool_calls()
      })
    }
  )
)

#' ModelResponseStream R6 Class
#' @param on_event Function. Callback function to handle all events.
#' The function should accept a single argument, `event`, which is a list
#' containing the event `type` and `data`.
#' @param on_output_text Function. Callback function to handle event that change output text. The function should accept a single argument
#' containing the output text string.
#' @param on_output_text_delta Function. Callback function to handle output
#' text delta events. The function should accept a single argument
#' containing the delta event data.
#' @param env Environment. The environment in which to evaluate the tool calls.
ModelResponseStream <- R6Class(
  "ModelResponseStream",
  inherit = ModelResponse,
  portable = FALSE,
  public = list(
    #' @description Initialize a `ModelResponseStream` object.
    #' @param stream_reader StreamReader. The stream reader object.
    #' @param init List. The initial response object.
    initialize = function(stream_reader = NULL, init = NULL) {
      if (is.null(stream_reader)) {
        super$store_response(init)
      } else {
        store_response(stream_reader)
      }
    },
    #' @description Stream the model response.
    stream = function(on_event = function(event) {},
                      on_output_text = function(output_text) {},
                      on_output_text_delta = function(data) {},
                      env = parent.frame()) {
      env <- force(env)
      handler <- event_handler(on_event, on_output_text, on_output_text_delta)
      if (.async) {
        stream_reader$stream_async(handle_event = handler) |> then(
          onFulfilled = ~ {
            tool_outputs <- do_tool_calls(env)
            if (!is.null(tool_outputs)) {
              submit_tool_outputs(tool_outputs) |> then(
                onFulfilled = ~ {
                  stream(on_event, on_output_text, on_output_text_delta, env)
                },
                onRejected = ~ {
                  cli_abort("Failed while submitting tool outputs", parent = .x)
                }
              )
            } else {
              self
            }
          },
          onRejected = ~ {
            cli_abort("Failed while reading the stream", parent = .x)
          }
        )
      } else {
        stream_reader$stream_sync(handle_event = handler)
        tool_outputs <- do_tool_calls(env)
        if (length(tool_outputs) > 0L) {
          stream_reader <<- submit_tool_outputs(tool_outputs)
          stream(on_event, on_output_text, on_output_text_delta, env)
        }
        invisible(self)
      }
    },
    #' @description Get the generator function for the stream.
    #' @param ... Additional arguments to pass to `oai_create_model_response()`.
    #' @return A coro package generator function.
    generator = function(...,
                         on_event = function(event) {},
                         on_output_text = function(output_text) {},
                         on_output_text_delta = function(data) {},
                         env = parent.frame()) {
      env <- force(env)
      handler <- event_handler(on_event, on_output_text, on_output_text_delta)
      respond(...)
      coro::gen({
        repeat {
          stream <- stream_reader$generator(handler)
          for (chunk in stream) {
            yield(chunk)
          }
          tool_outputs <- do_tool_calls(env)
          if (length(tool_outputs) > 0L) {
            submit_tool_outputs(tool_outputs)
            next
          } else {
            break
          }
        }
      })
    },
    #' @description Get the async generator function for the stream.
    #' @param ... Additional arguments to pass to `oai_create_model_response()`.
    async_generator = function(...,
                               on_event = function(event) {},
                               on_output_text = function(output_text) {},
                               on_output_text_delta = function(data) {},
                               env = parent.frame()) {
      env <- force(env)
      handler <- event_handler(on_event, on_output_text, on_output_text_delta)
      args <- list(...)
      args$.async <- TRUE
      coro::async_generator(function() {
        await(do.call(respond, args))
        repeat {
          stream <- stream_reader$async_generator(handler)
          for (i in coro::await_each(stream)) {
            yield(i)
          }
          tool_outputs <- do_tool_calls(env)
          if (length(tool_outputs) > 0L) {
            await(submit_tool_outputs(tool_outputs))
          } else {
            break
          }
        }
      })()
    }
  ),
  private = list(
    .stream = TRUE,
    stream_reader = NULL,
    store_response = function(resp) {
      if (is.promise(resp)) {
        resp$then(store_response) |>
          as_oai_promise()
      } else {
        stream_reader <<- resp
        .async <<- stream_reader$async %||% .async
        self
      }
    },
    event_handler = function(on_event, on_output_text, on_output_text_delta) {
      function(event) {
        event$type |> switch(
          "response.created" = ,
          "response.in_progress" = ,
          "response.completed" = ,
          "response.failed" = ,
          "response.incomplete" = {
            super$store_response(event$data$response)
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
            new_text <- paste0(
              output[[output_index]]$content[[content_index]]$text,
              event$data$delta
            )
            output[[output_index]]$content[[content_index]]$text <<- new_text
            output_text[output_index] <<- new_text
            on_output_text(output_text)
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
    }
  )
)
