#' Run API
#'
#' Runs represents executions run on a thread.
#' @inheritParams common_parameters
#' @return A Run R6 object.
#' @name run_api
NULL

#' @description * `oa_create_run()`: Create a new run.
#' @param thread_id Character. ID of the thread to run.
#' @param assistant_id Character. ID of the assistant to use to execute this run.
#' @param model Character. The ID of the Model to be used to execute this run. If a value is provided here, it will override the model associated with the assistant. If not, the model associated with the assistant will be used.
#' @param instructions Character. Overrides the instructions of the assistant. This is useful for modifying the behavior on a per-run basis.
#' @param additional_instructions Character. Appends additional instructions at the end of the instructions for the run. This is useful for modifying the behavior on a per-run basis without overriding other instructions.
#' @param additional_messages Character. Adds additional messages to the thread before creating the run.
#' @param tools Character. Override the tools the assistant can use for this run. This is useful for modifying the behavior on a per-run basis.
#' @param temperature Numeric. What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.
#' @param top_p Numeric. An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.
#' @param stream Logical. If TRUE, the function will return a RunStream object.
#' @param max_prompt_tokens Integer. The maximum number of prompt tokens that may be used over the course of the run. The run will make a best effort to use only the number of prompt tokens specified, across multiple turns of the run. If the run exceeds the number of prompt tokens specified, the run will end with status incomplete. See incomplete_details for more info.
#' @param max_completion_tokens Integer. The maximum number of completion tokens that may be used over the course of the run. The run will make a best effort to use only the number of completion tokens specified, across multiple turns of the run. If the run exceeds the number of completion tokens specified, the run will end with status incomplete. See incomplete_details for more info.
#' @param truncation_strategy Object. Controls for how a thread will be truncated prior to the run. Use this to control the intial context window of the run.
#' @param tool_choice Character. Controls which (if any) tool is called by the model. none means the model will not call any tools and instead generates a message. auto is the default value and means the model can pick between generating a message or calling one or more tools. required means the model must call one or more tools before responding to the user.
#' @param response_format Character. Specifies the format that the model must output. Compatible with GPT-4o, GPT-4 Turbo, and all GPT-3.5 Turbo models since gpt-3.5-turbo-1106.
#' @rdname run_api
#' @export
oai_create_run <- function(thread_id,
                           assistant_id,
                           model = NULL,
                           instructions = NULL,
                           additional_instructions = NULL,
                           additional_messages = NULL,
                           tools = NULL,
                           metadata = NULL,
                           temperature = NULL,
                           top_p = NULL,
                           stream = NULL,
                           max_prompt_tokens = NULL,
                           max_completion_tokens = NULL,
                           truncation_strategy = NULL,
                           tool_choice = NULL,
                           response_format = NULL,
                           .classify_response = TRUE,
                           .async = FALSE) {
  if (inherits(thread_id, "Thread")) {
    thread_id <- thread_id$id
  }
  if (inherits(assistant_id, "Assistant")) {
    assistant_id <- assistant_id$id
  }
  body <- list(
    assistant_id = assistant_id,
    model = model,
    instructions = instructions,
    additional_instructions = additional_instructions,
    additional_messages = additional_messages,
    tools = tools,
    metadata = metadata,
    temperature = temperature,
    top_p = top_p,
    stream = stream,
    max_prompt_tokens = max_prompt_tokens,
    max_completion_tokens = max_completion_tokens,
    truncation_strategy = truncation_strategy,
    tool_choice = tool_choice,
    response_format = response_format
  )
  oai_query(
    c("threads", thread_id, "runs"),
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_create_thread_and_run()`: Create a new thread and run.
#' @param thread List. A named list of thread parameters: "messages" (List), "tool_resources" (List), "metadata" (List).
#' @param tool_resources List. A list of resources that are used by the assistant's tools. The resources are specific to the type of tool. For example, the code_interpreter tool requires a list of file IDs, while the file_search tool requires a list of vector store IDs.
#' @export
#' @rdname run_api
oai_create_thread_and_run <- function(assistant_id,
                                      thread = NULL,
                                      model = NULL,
                                      instructions = NULL,
                                      tools = NULL,
                                      tool_resources = NULL,
                                      metadata = NULL,
                                      temperature = NULL,
                                      top_p = NULL,
                                      stream = NULL,
                                      max_prompt_tokens = NULL,
                                      max_completion_tokens = NULL,
                                      truncation_strategy = NULL,
                                      tool_choice = NULL,
                                      response_format = NULL,
                                      .classify_response = TRUE,
                                      .async = FALSE) {
  if (inherits(thread, "oai_message") || is.character(thread)) {
    thread <- oai_thread(thread)
  }
  body <- list(
    assistant_id = assistant_id,
    thread = thread,
    model = model,
    instructions = instructions,
    tools = tools,
    tool_resources = tool_resources,
    metadata = metadata,
    temperature = temperature,
    top_p = top_p,
    stream = stream,
    max_prompt_tokens = max_prompt_tokens,
    max_completion_tokens = max_completion_tokens,
    truncation_strategy = truncation_strategy,
    tool_choice = tool_choice,
    response_format = response_format
  )
  oai_query(
    c("threads", "runs"),
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_list_runs()`: List runs.
#' @return `oai_list_runs()` returns a list of `Run` objects.
#' @export
#' @rdname run_api
oai_list_runs <- function(thread_id,
                          limit = NULL,
                          order = NULL,
                          after = NULL,
                          before = NULL,
                          .classify_response = TRUE,
                          .async = FALSE) {
  query <- list(
    limit = as.integer(limit),
    order = order,
    after = after,
    before = before
  )
  oai_query_list(
    c("threads", thread_id, "runs"),
    headers = openai_beta_header(),
    method = "GET",
    query = query,
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_list_run_steps()`: List run steps.
#' @param run_id Character. ID of the run.
#' @return `oai_list_run_steps()` returns a list of `RunStep` objects.
#' @export
#' @rdname run_api
oai_list_run_steps <- function(thread_id,
                               run_id,
                               limit = NULL,
                               order = NULL,
                               after = NULL,
                               before = NULL,
                               .classify_response = TRUE,
                               .async = FALSE) {
  query <- list(
    limit = as.integer(limit),
    order = order,
    after = after,
    before = before
  )
  oai_query_list(
    c("threads", thread_id, "runs", run_id, "steps"),
    headers = openai_beta_header(),
    method = "GET",
    query = query,
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_retrieve_run()`: Retrieve a run.
#' @export
#' @rdname run_api
oai_retrieve_run <- function(thread_id, run_id,
                             .classify_response = TRUE,
                             .async = FALSE) {
  oai_query(
    c("threads", thread_id, "runs", run_id),
    headers = openai_beta_header(),
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_modify_run()`: Modify a run.
#' @return `oai_modify_run()` returns a `Run` object.
#' @export
#' @rdname run_api
oai_modify_run <- function(thread_id,
                           run_id,
                           metadata = NULL,
                           .classify_response = TRUE,
                           .async = FALSE) {
  body <- list(
    metadata = metadata
  )
  oai_query(
    c("threads", thread_id, "runs", run_id),
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_cancel_run()`: Cancel a run.
#' @return `oai_cancel_run()` returns a `Run` object.
#' @export
#' @rdname run_api
oai_cancel_run <- function(thread_id,
                           run_id,
                           .classify_response = TRUE,
                           .async = FALSE) {
  oai_query(
    c("threads", thread_id, "runs", run_id, "cancel"),
    headers = openai_beta_header(),
    method = "POST",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_submit_tool_outputs()`: Submit tool outputs.
#' @param tool_outputs List of tool outputs.
#' @return `oai_submit_tool_outputs()` returns a `Run` object.
#' @export
#' @rdname run_api
oai_submit_tool_outputs <- function(thread_id,
                                    run_id,
                                    tool_outputs,
                                    stream = NULL,
                                    .classify_response = TRUE,
                                    .async = FALSE) {
  body <- list(
    tool_outputs = tool_outputs,
    stream = stream
  )
  oai_query(
    c("threads", thread_id, "runs", run_id, "submit_tool_outputs"),
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response,
    .async = .async
  )
}

#' @description * `oai_tool_output()`: A helper function to format a tool output.
#' @param tool_call_id Character. The ID of the tool call in the required_action object within the run object the output is being submitted for.
#' @param output Character. The output of the tool call to be submitted to continue the run.
#' @export
#' @rdname run_api
oai_tool_output <- function(tool_call_id, output) {
  stopifnot(is.character(tool_call_id) && length(tool_call_id) == 1)
  stopifnot(is.character(output) && length(output) == 1)
  list(
    tool_call_id = tool_call_id,
    output = output
  )
}

#' Run R6 class
#'
#' @param thread_id Thread ID or Thread object
#' @param run_id Run ID.
#' @param assistant_id Assistant ID or Assistant object.
#' @param resp Response object.
#' @param env Environment to evaluate tool calls.
#' @param tool_outputs Tool outputs.
#' @param ... Additional arguments passed to the API function.
#' @param .async Logical. If TRUE, the API call will be asynchronous.
#' @importFrom jsonlite fromJSON
#' @importFrom R6 R6Class
#' @importFrom later later
#' @importFrom promises promise
#' @rdname Run
#' @export
Run <- R6Class(
  "Run",
  portable = FALSE,
  inherit = Utils,
  public = list(
    #' @description Initialize a Run object. If `thread_id` and `run_id` are provided, the Run object is initialized with the corresponding run. If `thread_id` and `assistant_id` are provided, a new run is created.
    initialize = function(thread_id = NULL,
                          run_id = NULL,
                          assistant_id = NULL,
                          ...,
                          resp = NULL,
                          .async = FALSE) {
      if (!is.null(thread_id) & !is.null(run_id)) {
        oai_retrieve_run(
          thread_id = tread_id,
          run_id = run_id,
          .classify_response = FALSE,
          .async = .async
        ) |>
          store_response()
      } else if (!is.null(thread_id) & !is.null(assistant_id)) {
        if (inherits(thread_id, "Thread")) {
          thread_id <- thread_id$id
        }
        if (inherits(assistant_id, "Assistant")) {
          assistant_id <- assistant_id$id
        }
        oai_create_run(
          thread_id = thread_id,
          assistant_id = assistant_id,
          ...,
          .classify_response = FALSE,
          .async = .async
        ) |>
          store_response()
      } else if (!is.null(resp)) {
        store_response(resp)
      } else {
        cli_abort("Must provide either 'thread_id' and 'run_id' or 'thread_id' and 'assistant_id'!")
      }
    },
    #' @field id Run ID.
    id = NULL,
    #' @field created_at Time the run was created.
    created_at = NULL,
    #' @field thread_id Thread ID.
    thread_id = NULL,
    #' @field assistant_id Assistant ID.
    assistant_id = NULL,
    #' @field status Run status.
    status = NULL,
    #' @field required_action Required action.
    required_action = NULL,
    #' @field last_error Last error.
    last_error = NULL,
    #' @field started_at Time the run was started.
    started_at = NULL,
    #' @field expires_at Time the run expires.
    expires_at = NULL,
    #' @field cancelled_at Time the run was cancelled.
    cancelled_at = NULL,
    #' @field failed_at Time the run failed.
    failed_at = NULL,
    #' @field completed_at Time the run was completed.
    completed_at = NULL,
    #' @field incomplete_details Incomplete details.
    incomplete_details = NULL,
    #' @field model Model.
    model = NULL,
    #' @field instructions Instructions.
    instructions = NULL,
    #' @field tools Tools.
    tools = NULL,
    #' @field metadata Metadata.
    metadata = NULL,
    #' @field usage Usage.
    usage = NULL,
    #' @field temperature Temperature.
    temperature = NULL,
    #' @field top_p Top p.
    top_p = NULL,
    #' @field max_prompt_tokens Maximum prompt tokens.
    max_prompt_tokens = NULL,
    #' @field max_completion_tokens Maximum completion tokens.
    max_completion_tokens = NULL,
    #' @field truncation_strategy Truncation strategy.
    truncation_strategy = NULL,
    #' @field tool_choice Tool choice.
    tool_choice = NULL,
    #' @field response_format Response format.
    response_format = NULL,
    #' @description Retrieve the run. The `...` argument is passed to `oai_list_run steps()`.
    #' @return `list_steps()` returns a list of `RunStep` objects.
    list_steps = function(...) {
      oai_list_run_steps(
        thread_id = self$thread_id,
        run_id = self$id,
        ...
      )
    },
    #' @description Retrieve the run.
    retrieve = function() {
      oai_retrieve_run(
        thread_id = self$thread_id,
        run_id = self$id,
        .classify_response = FALSE,
        .async = .async
      ) |>
        store_response()
    },
    #' @description Retrieve the up-to-date status of the run.
    retrieve_status = function() {
      if (.async) {
        retrieve() |> then(function(x) x$status)
      } else {
        self$retrieve()$status
      }
    },
    #' @description Modify the metadata of the run.
    modify = function(...) {
      oai_modify_run(
        thread_id = self$thread_id,
        run_id = self$id,
        ...,
        .classify_response = FALSE,
        .async = .async
      ) |> store_response()
    },
    #' @description Cancel the run.
    cancel = function() {
      oai_cancel_run(
        thread_id = self$thread_id,
        run_id = self$id,
        .async = .async
      ) |>
        store_response()
    },
    #' @description Submit tool outputs.
    #' @param stream Logical. If TRUE, the function will return a RunStream object.
    submit_tool_outputs = function(tool_outputs, stream = NULL) {
      r <- oai_submit_tool_outputs(
        thread_id = self$thread_id,
        run_id = self$id,
        tool_outputs = tool_outputs,
        stream = stream,
        .classify_response = FALSE,
        .async = .async
      )
      if (isTRUE(stream)) {
        r
      } else {
        store_response(r)
      }
    },
    #' @description Wait for the run to complete.
    wait = function(env = parent.frame()) {
      start_time <- Sys.time()
      repeat {
        s <- self$retrieve_status()
        if (s %in% c("queued", "in_progress", "cancelling")) {
          run_time <-
            as.numeric(difftime(Sys.time(), start_time, units = "secs"))
          if (run_time > getOption("openaiapi.run_timeout")) {
            cli_abort("Run took too long to complete.")
          }
          ## Wait for the run to complete.
          Sys.sleep(getOption("openaiapi.run_poll_interval"))
        } else if (s %in% c("failed", "cancelled", "expired")) {
          ## Throw an error if the run failed.
          cli_abort("Run ended with status \"{s}\"")
        } else if (s == "requires_action") {
          ## Perform the required action.
          self$do_tool_calls(env) |>
            self$submit_tool_outputs() |>
            store_response()
          Sys.sleep(getOption("openaiapi.run_poll_interval"))
        } else if (s == "completed") {
          ## Return the run object when completed.
          return(self)
        } else {
          cli_abort("Run has unknown status \"{s}\"")
        }
      }
    },
    #' @description Perform tool calls asynchronously. Returns a promise.
    await = function(env = parent.frame()) {
      .async <<- TRUE
      start_time <- Sys.time()
      promise(function(resolve, reject) {
        handle_calls <- function() {
          run_time <-
            as.numeric(difftime(Sys.time(), start_time, units = "secs"))
          if (run_time > getOption("openaiapi.run_timeout")) {
            reject("Run took too long to complete.")
          }
          later(function() {
            self$retrieve_status() |> then(function(s) {
              if (s %in% c("queued", "in_progress", "cancelling")) {
                ## Wait for the run to complete.
                handle_calls()
              } else if (s %in% c("failed", "cancelled", "expired")) {
                ## Throw an error if the run failed.
                reject(paste("Run ended with status", s))
              } else if (s == "requires_action") {
                ## Perform the required action.
                self$do_tool_calls(env) |>
                  self$submit_tool_outputs() |>
                  store_response() |>
                  then(handle_calls)
              } else if (s == "completed") {
                ## Return the run object when completed.
                resolve(self)
              } else {
                reject(paste("Run has unknown status", s))
              }
            })
          },
          delay = getOption("openaiapi.run_poll_interval")
          )
        }
        handle_calls()
      })
    },
    #' @description Perform tool calls. Returns a list of tool outputs.
    do_tool_calls = function(env = parent.frame()) {
      a <- self$required_action
      if (a$type  != "submit_tool_outputs") {
        cli_abort("Required action not of type 'submit_tool_outputs'.")
      }
      ## Note that this still relies on the object's tools field,
      ## which is retrieved from the API. This is a potential security risk.
      .do_tool_calls(a$submit_tool_outputs$tool_calls, env, self$tools)
      ## lapply(a$submit_tool_outputs$tool_calls, function(x) {
      ##   if (x$type != "function") {
      ##     cli_abort(
      ##       "Tool call not of type 'function'.",
      ##       call = call("self$do_tool_calls")
      ##     )
      ##   }
      ##   output <- tryCatch(
      ##     ## Note that this function still relies on the object's tools field,
      ##     ## which is retrieved from the API. This is a potential security risk.
      ##     do_call_sandbox(x$`function`, env, self$tools),
      ##     error = function(cnd) {
      ##       cli_abort("Function tool call failed.", parent = cnd,
      ##                 call = call("self$do_tool_calls"))
      ##     }
      ##   )
      ##   list(tool_call_id = x$id, output = output)
      ## })
    },
    #' @description Retrieve the thread of the run.
    thread = function() {
      oai_retrieve_thread(self$thread_id)
    },
    #' @description Retrieve the assistant of the run.
    assistant = function() {
      oai_retrieve_assistant(self$assistant_id)
    }
  ),
  private = list(
    schema = list(
      as_is = c(
        "id", "thread_id", "assistant_id", "status",
        "required_action", "last_error", "incomplete_details",
        "model", "instructions", "tools", "metadata", "usage",
        "temperature", "top_p", "max_prompt_tokens", "max_completion_tokens",
        "truncation_strategy", "tool_choice", "response_format"
      ),
      as_time = c(
        "created_at", "expires_at", "started_at", "cancelled_at",
        "failed_at", "completed_at"
      )
    )## ,
    ## make_sanbox_env = function(env) {
    ##   ## TODO: Use a wrapper on do.call instead, check arguments against the function signature.
    ##   function_tool_names <- sapply(tools, function(x) x$`function`$name)
    ##   if (length(function_tool_names) == 0) {
    ##     emptyenv()
    ##   } else {
    ##     env_get_list(
    ##       env = env,
    ##       nms = function_tool_names,
    ##       inherit = TRUE
    ##     ) |> as.environment()
    ##   }
    ## }
  )
)

#' RunStream R6 class
#' @rdname Run
#' @export
RunStream <- R6Class(
  "RunStream",
  inherit = Run,
  portable = FALSE,
  public = list(
    #' @field event_data Data accumulated from the event stream.
    event_data = list(),
    #' @description Initialize a RunStream object.
    #' @param stream_reader StreamReader object.
    initialize = function(stream_reader) {
      stream_reader <<- stream_reader
      .async <<- stream_reader$async
    },
    #' @description Stream the run asynchronously.
    #' @param on_message_delta A callback function to handle message delta events.
    #' @param on_message A callback function to handle all message events.
    #' @param on_run_step_delta A callback function to handle run step delta events.
    #' @param on_run_step A callback function to handle all run step events.
    #' @param on_event A callback function to handle all events.
    #' @param env Environment to evaluate tool calls.
    stream_async = function(on_message_delta = function(data) {},
                            on_message = function(msg) {},
                            on_run_step_delta = function(data) {},
                            on_run_step = function(step) {},
                            on_event = function(event) {},
                            env = parent.frame()) {
      stream_reader$stream_async(
        handle_event = function(event) {
          id <- event$data$id
          event$type |> switch(
            ## THREAD----------------
            "thread.created" = {
              event_data$thread <<- Thread$new(resp = event$data)
            },
            ## MESSAGE----------------
            "thread.message.created" = ,
            "thread.message.in_progress" = ,
            "thread.message.completed" = ,
            "thread.message.incomplete" = {
              if (is.null(event_data$messages[[id]])) {
                event_data$messages[[id]] <<- Message$new(resp = event$data)
              } else {
                event_data$messages[[id]]$store_response(event$data)
              }
              on_message(event_data$messages[[id]])
            },
            "thread.message.delta" = {
              on_message_delta(event$data)
              event_data$messages[[id]]$add_delta(event$data$delta)
              on_message(event_data$messages[[id]])
            },
            ## RUN --------------------
            "thread.run.created" = ,
            "thread.run.cancelled" = ,
            "thread.run.cancelling" = ,
            "thread.run.completed" = ,
            "thread.run.expired" = ,
            "thread.run.failed" = ,
            "thread.run.in_progress" = ,
            "thread.run.incomplete" = ,
            "thread.run.queued" = ,
            "thread.run.requires_action" = store_response(event$data),
            ## RUN STEP ----------------
            "thread.run.step.cancelled" = ,
            "thread.run.step.completed" = ,
            "thread.run.step.created" = ,
            "thread.run.step.expired" = ,
            "thread.run.step.failed" = ,
            "thread.run.step.in_progress" = {
              if (is.null(event_data$run_steps[[id]])) {
                event_data$run_steps[[id]] <<- RunStep$new(resp = event$data)
              } else {
                event_data$run_steps[[id]]$store_response(event$data)
              }
              on_run_step(event_data$run_steps[[id]])
            },
            "thread.run.step.delta" = {
              on_run_step_delta(event$data)
              event_data$run_steps[[id]]$add_delta(event$data$delta)
              on_run_step(event_data$run_steps[[id]])
            },
            NULL
          )
          on_event(event)
        }
      ) |>
        then(function(...) {
          if (identical(required_action$type, "submit_tool_outputs")) {
            ## Perform tool calls, submit tool outputs, and continue streaming.
            do_tool_calls(env) |>
              submit_tool_outputs(stream = TRUE) |> # returns StreamReader obj
              then(function(new_stream_reader) {
                stream_reader <<- new_stream_reader
                stream_async(
                  on_message_delta = on_message_delta,
                  on_run_step_delta = on_run_step_delta,
                  on_message = on_message,
                  on_run_step = on_run_step,
                  on_event = on_event,
                  env = env
                )
              })
          } else {
            self
          }
        })
    }
  ),
  private = list(
    stream_reader = NULL
  )
)

