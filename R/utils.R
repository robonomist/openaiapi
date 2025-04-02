#' @keywords internal
isEmpty <- function(x) {
  is.null(x) || length(x) == 0L
}

#' Compact a list
#' @keywords internal
## compact <- function(x) {
##   x <- base::Filter(base::Negate(isEmpty), x)
##   if (length(x)) x else NULL
## }
compact <- function(x) {
  x <- lapply(x, function(el) {
    if (is.list(el)) compact(el) else el
  })
  x <- Filter(Negate(isEmpty), x)
  if (length(x)) x else NULL
}

#' @keywords internal
as_time <- function(x) {
  as.POSIXct(x, tz = "UTC")
}

detect_index <- function(x, p) {
  for (i in seq_along(x)) {
    if (p(x[[i]])) {
      return(i)
    }
  }
  0L
}

#' @export
make_sandbox <- function(tools = NULL, env = parent.frame()) {
  tools <- force(tools)
  if (is.null(tools)) {
    env <- emptyenv()
    allow_call <- FALSE
  } else {
    function_tool_names <- sapply(tools, function(x) x$`function`$name)
    env <- env_get_list(
      env = env,
      nms = function_tool_names,
      inherit = TRUE
    ) |> as.environment()
    allow_call <- TRUE
  }
  function(tool_calls) {
    if (!allow_call) {
      cli_abort(c(
        "x" = "A tool call was attempted while the sandbox is empty.",
        "!" = "Use `sandbox = make_sandbox(tools)` to provied a sandbox in which tool calls can be made safely."
      ))
    }
    .do_tool_calls(tool_calls, env, tools)
  }
}

#' Validate and call a tool function
#'
#' @keywords internal
do_call_sandbox <- function(tool_call_function, env, tools) {
  what <- tool_call_function$name
  args <- fromJSON(
    tool_call_function$arguments,
    simplifyVector = getOption("openaiapi.tool_call_simplifyVector", TRUE)
  )
  ## Check if the function is allowed
  tool_index <- detect_index(tools, function(tool) {
    identical(tool$`function`$name, what)
  })
  if (tool_index == 0L) {
    cli_abort("Function '{what}' is not allowed in the sandbox.")
  }
  ## Check if the arguments are allowed
  tool <- tools[[tool_index]]
  allowed_args <- names(tool$`function`$parameters$properties)
  unallowed_args <- setdiff(names(args), allowed_args)
  if (length(unallowed_args)) {
    a <- paste(unallowed_args, collapse = "', '")
    cli_abort("Arguments '{a}' are not allowed in the sandbox.")
  }
  output <- do.call(what, args, envir = env)
  if (!is.character(output) || length(output) != 1) {
    cli_abort(c(
      "Function tool `{what}` returned an invalid output.",
      x = "Tool functions must return a character vector of length 1!"
    ))
  }
  output
}

#' @keywords internal
.do_tool_calls <- function(tool_calls, env, tools) {
  lapply(tool_calls, function(x) {
    if (x$type != "function") {
      cli_abort("Tool call not of type 'function'.")
    }
    output <- tryCatch(
      do_call_sandbox(x$`function`, env, tools),
      error = function(cnd) {
        cli_abort("Function tool call failed.", parent = cnd)
      }
    )
    list(tool_call_id = x$id, output = output)
  })
}
