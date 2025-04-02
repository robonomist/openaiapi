#' @description * `oai_retrieve_run_step()`: Retrieve a run step.
#' @param step_id Character. ID of the step.
#' @return `oai_retrieve_run_step()` returns a `RunStep` object.
#' @export
#' @rdname run_api
oai_retrieve_run_step <- function(thread_id, run_id, step_id,
                                  .classify_response = TRUE,
                                  .async = FALSE) {
  oai_query(
    c("threads", thread_id, "runs", run_id, "steps", step_id),
    headers = openai_beta_header(),
    .classify_response = .classify_response,
    .async = .async
  )
}


#' @importFrom R6 R6Class
RunStep <- R6Class(
  "RunStep",
  inherit = Utils,
  portable = FALSE,
  public = list(
    initialize = function(thread_id = NULL,
                          run_id = NULL,
                          step_id = NULL,
                          ...,
                          resp,
                          .async = FALSE) {
      if (!is.null(resp)) {
        store_response(resp)
      } else if (!is.null(thread_id) & !is.null(run_id) & !is.null(run_step_id)) {
        oai_retrieve_run_step(
          thread_id = thread_id,
          run_id = run_id,
          step_id = step_id,
          .classify_response = FALSE,
          .async = .async
        ) |>
          store_response()
      } else {
        cli_abort("Must provide 'thread_id', 'run_id', and 'step_id'!")
      }
    },
    id = NULL,
    created_at = NULL,
    assistant_id = NULL,
    thread_id = NULL,
    run_id = NULL,
    type = NULL,
    status = NULL,
    step_details = NULL,
    last_error = NULL,
    expired_at = NULL,
    cancelled_at = NULL,
    failed_at = NULL,
    completed_at = NULL,
    metadata = NULL,
    usage = NULL,
    retrieve = function() {
      oai_retrieve_run_step(
        thread_id = self$thread_id,
        run_id = self$run_id,
        step_id = self$id,
        .classify_response = FALSE,
        .async = .async
      ) |> store_response()
    },
    do_tool_calls = function(env = parent.frame()) {
      if (self$step_details$type != "tool_calls") {
        cli_abort("Run step not of type 'tool_calls'.")
      }
      sandbox_env <- make_sanbox_env(env)
      lapply(self$step_details$tool_calls, function(x) {
        if (x$type != "function") {
          cli_abort("Tool call not of type 'function'.",
                    call = call("self$do_tool_calls"))
        }
        output <- tryCatch(
          do.call(
            what = x$`function`$name,
            args = fromJSON(x$`function`$arguments),
            envir = sandbox_env
          ),
          error = function(cnd) {
            cli_abort("Function tool call failed.", parent = cnd,
                      call = call("self$do_tool_calls"))
          }
        )
        if (!is.character(output) || length(output) != 1) {
          cli_abort(c(
            "Function tool `{x$`function`$name}` returned an invalid output.",
            x = "Tool functions must return a character vector of length 1!"
          ), call = call("self$do_tool_calls"))
        }
        list(tool_call_id = x$id, output = output)
      })
    },
    submit_tool_outputs = function() {
      oai_submit_tool_outputs(
        thread_id = self$thread_id,
        run_id = self$run_id,
        tool_outputs = self$do_tool_calls()
      )
    },
    retrieve_message = function() {
      if (self$step_details$type == "message_creation") {
        oai_retrieve_message(
          thread_id = self$thread_id,
          message_id = self$step_details$message_creation$message_id
        )
      } else {
        cli_abort("Run step not of type 'message_creation'.")
      }
    },
    assistant = function() {
      oai_retrieve_assistant(self$assistant_id, .async = .async)
    },
    thread = function() {
      oai_retrieve_thread(self$thread_id, .async = .async)
    },
    run = function() {
      oai_retrieve_run(self$thread_id, self$run_id, .async = .async)
    },
    add_delta = function(delta) {
      if (is.null(step_details$tool_calls)) {
        step_details <<- delta$step_details
      } else {
        for (tool_call in delta$step_details$tool_calls) {
          i <- tool_call$index + 1L
          tool_call$`function`$arguments <- paste0(
            step_details$tool_calls[[i]]$`function`$arguments %||% "",
            tool_call$`function`$arguments
          )
          step_details$tool_calls[[i]] <<- modifyList(
            step_details$tool_calls[[i]], tool_call
          )
        }
        step_details <<- modifyList(step_details, delta$step_details)
      }
      self
    }
  ),
  private = list(
    schema = list(
      as_is = c(
        "id", "assistant_id", "thread_id", "run_id", "type", "status",
        "step_details", "last_error", "metadata", "usage"
      ),
      as_time = c(
        "created_at", "expired_at", "cancelled_at", "failed_at", "completed_at"
      )
    )
  )
)
