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
#' Create a sandbox environment for function tools
#'
#' For convenience, all function tools calling methods, by default, are evaluated in the parent frame. This poses a security risk, as the function tools call, which is receved from the API, can access the environment of the caller (and thus potentially any function or variable in R). This function creates a sandbox environment for the function tools, which is a copy of the parent frame, but without any unnecessary variables or functions from the parent frame. This sandbox environment can be used to evaluate the function tools in a safe manner.
#'
#' @param tools A list of function tools.
#' @param env The environment to use to find the function tools. Defaults to the parent frame.
#' @export
make_sandbox_env <- function(tools, env = parent.frame()) {
  if (inherits(tools, "oai_function_tool")) {
    tools <- list(tools)
  }
  function_tool_names <- sapply(tools, function(x) x$`function`$name)
  env <- env_get_list(
    env = env,
    nms = function_tool_names,
    inherit = TRUE
  ) |> as.environment()

  ## Create a wapper function for each tool adding validation
  for (i in seq_along(tools)) {
    fun <- tools[[i]]$`function`$name
    assign(
      fun,
      function(...) {
        ## validate_tool_call(fun, list(...), tools)
        args <- list(...)
        allowed_args <- names(tools[[i]]$`function`$parameters$properties)
        unallowed_args <- setdiff(names(args), allowed_args)
        if (length(unallowed_args)) {
          a <- paste(unallowed_args, collapse = "', '")
          cli_abort("Arguments '{a}' are not allowed in the sandbox.")
        }
        do.call(fun, args, envir = env)
      },
      envir = env
    )
  }
  env
}

#' Validate and call a tool function
#' @keywords internal
do_call_sandbox <- function(tool_call_function, env) {
  what <- tool_call_function$name
  args <- fromJSON(
    tool_call_function$arguments,
    simplifyVector = getOption("openaiapi.tool_call_simplifyVector", TRUE)
  )
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
.do_tool_calls <- function(tool_calls, env) {
  lapply(tool_calls, function(x) {
    if (x$type != "function") {
      cli_abort("Tool call not of type 'function'.")
    }
    output <- tryCatch(
      do_call_sandbox(x$`function`, env),
      error = function(cnd) {
        cli_abort("Function tool call failed.", parent = cnd)
      }
    )
    list(tool_call_id = x$id, output = output)
  })
}
