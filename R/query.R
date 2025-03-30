#' Set OpenAI API key
#'
#' To use the OpenAI API, you need to have an API key. You can get one by signing up at [OpenAI](https://platform.openai.com/).
#'
#' Alternatively, you can set the `OPENAI_API_KEY` environment variable, which is read at package load time.
#'
#' @param api_key A character string with the OpenAI API key.
#' @export
oai_set_api_key <- function(api_key) {
  options(openaiapi.api_key = api_key)
}

#' @keywords internal
openai_beta_header <- function() {
  version <- getOption("openaiapi.assistants_version")
  list(`OpenAI-Beta` = paste0("assistants=", version))
}

#' @keywords internal
oai_request <- function(ep, body, method, headers, encode) {
  ## Body can not a empty list
  body <- if (length(body)) body else NULL
  req <-
    request("https://api.openai.com/v1") |>
    req_url_path_append(ep) |>
    req_headers(
      Authorization = paste("Bearer", getOption("openaiapi.api_key")),
      !!!headers
    ) |>
    req_method(method) |>
    req_error(body = oai_error_body)
  if (!is.null(body) && encode == "json") {
    req <- req_body_json(req, body, force = TRUE)
  } else if (encode == "multipart") {
    req <- req_body_multipart(req, !!!body)
  }
  req
}

#' @keywords internal
#' @importFrom glue glue
oai_error_body <- function(resp) {
  error <- resp_body_json(resp)$error
  c(
    "!" = glue('OpenAI API returned an error of type "{error$type}" (error code: {error$code})'),
    "!" = if (!is.null(error$param)) {
      glue("Caused by parameter {error$param}")
    },
    "i" = error$message
  )
}

stamp <- function(x = "") {
  ## High precision timestamp
  cat(x, format(Sys.time(), "%Y-%m-%d %H:%M:%OS3"), "\n")
}

#' @keywords internal
oai_query <- function(ep,
                      body = NULL,
                      query = NULL,
                      method = "GET",
                      encode = "json",
                      headers = NULL,
                      path = NULL,
                      .classify_response = TRUE,
                      .async = FALSE,
                      .stream = NULL) {
  req <- oai_request(ep, body, method, headers, encode)

  if (!is.null(.stream)) {
    if (.async) {
      ## Handle async streaming case
      p <- promise(function(resolve, reject) {
        later(function() {
          ## TODO: This should be made a promise that resolves when the connection is established
          con <- req_perform_connection(req, blocking = !.async)
          s <- Stream$new(con, .async = .async)
          resolve(classify_stream(s, class = .stream))
        })
      }) |>
        as_oai_promise()
      return(p)
    } else {
      ## Handle sync streaming case
      con <- req_perform_connection(req, blocking = !.async)
      s <- Stream$new(con, .async = .async)
      if (.classify_response) {
        s <- classify_stream(s, class = .stream)
      }
      return(s)
    }
  } else {
    ## Handle non-streaming case
    handle_response <- function(resp) {
      if (!is.null(path)) {
        invisible(path)
      } else {
        b <- resp_body_json(resp)
        b$.async <- .async
        if (.classify_response) {
          classify_response(b)
        } else {
          b
        }
      }
    }
    if (.async) {
      ## Handle async non-streaming case
      req_perform_promise(req, path = path) |>
        then(handle_response) |>
        as_oai_promise()
    } else {
      ## Handle sync non-streaming case
      req_perform(req, path = path)|>
        handle_response()
    }
  }
}

as_oai_promise <- function(p) {
  class(p) <- c("oai_promise", class(p))
  p
}

#' @export
`$.oai_promise` <- function(x, name) {
  if (name %in% names(x)) {
    ## Regular promise methods: then, catch, finally
    x[[name]]
  } else {
    function(...) {
      args <- list(...)
      env <- caller_env()
      x$then(function(y) {
        do.call(y[[name]], args, envir = env)
      }) |> as_oai_promise()
    }
  }
}


#' @keywords internal
oai_query_list <- function(...) {
  args <- list(...)
  if (isFALSE(args$.classify_response)) {
    return(oai_query(...))
  }

  if (!is.null(args$query$limit) && args$query$limit > 100) {
    requested_limit <- args$query$limit
    args$query$limit <- 100
  } else {
    requested_limit <- 100
  }

  initial_resp <- do.call(oai_query, args)

  if (isTRUE(args$.async)) {
    fetch_recursive_async <- function(accumulated_resp, n) {
      if (n >= requested_limit || !attr(accumulated_resp, "has_more")) {
        return(accumulated_resp)
      }
      args$query$after <- attr(accumulated_resp, "last_id")
      args$query$limit <- min(100, requested_limit - n)
      do.call(oai_query, args) |> then(function(next_resp) {
        combined <- append(accumulated_resp, next_resp)
        attr(combined, "last_id") <- attr(next_resp, "last_id")
        attr(combined, "has_more") <- attr(next_resp, "has_more")
        fetch_recursive_async(combined, length(combined))
      })
    }

    initial_resp |> then(function(resp) {
      n <- length(resp)
      fetch_recursive_async(resp, n)
    })
  } else {
    # Inner recursive function
    fetch_recursive <- function(accumulated_resp, n) {
      if (n >= requested_limit || !attr(accumulated_resp, "has_more")) {
        return(accumulated_resp)
      }

      args$query$after <- attr(accumulated_resp, "last_id")
      args$query$limit <- min(100, requested_limit - n)
      next_resp <- do.call(oai_query, args)
      combined <- append(accumulated_resp, next_resp)
      attr(combined, "last_id") <- attr(next_resp, "last_id")
      attr(combined, "has_more") <- attr(next_resp, "has_more")
      fetch_recursive(combined, length(combined))
    }

    initial_resp <- do.call(oai_query, args)
    n <- length(initial_resp)
    fetch_recursive(initial_resp, n)
  }
}

oai_list <- function(x) {
  structure(
    lapply(x$data, classify_response),
    first_id = x$first_id,
    last_id = x$last_id,
    has_more = x$has_more,
    class = c("oai_list", "list")
  )
}

classify_response <- function(x) {
  switch(x$object,
    "list" = oai_list(x),
    "chat.completion" = ChatCompletion$new(resp = x),
    "assistant" = Assistant$new(resp = x),
    "thread" = Thread$new(resp = x),
    "thread.run" = Run$new(resp = x),
    "thread.run.step" = RunStep$new(resp = x),
    "thread.message" = Message$new(resp = x),
    "vector_store" = VectorStore$new(resp = x),
    "vector_store.file" = VectorStoreFile$new(resp = x),
    "vector_store.file_batch" = VectorStoreFilesBatch$new(resp = x),
    "file" = File$new(resp = x),
    "embedding" = Embedding$new(resp = x),
    x
  )
}

classify_stream <- function(x, class) {
  switch(
    class,
    "ChatCompletion" = ChatCompletionStream$new(x),
    x
  )
}

#' @importFrom jsonlite fromJSON
#' @importFrom curl multi_fdset
#' @keywords internal
Stream <- R6Class(
  "Stream",
  portable = FALSE,
  public = list(
    initialize = function(con, .async = FALSE) {
      async <<- .async
      con <<- con
    },
    read = function() {
      event <- resp_stream_sse(con)
      if (is.null(event)) return(NULL)
      data <- event$data
      if (data == "[DONE]") {
        close(private$con)
        "[DONE]"
      } else {
        fromJSON(data, simplifyVector = FALSE)
      }
    },
    stream_async = function(handle_event) {
      promise(function(resolve, reject) {
        handle_stream <- function(...) {
          event <- read()
          if (identical(event, "[DONE]")) {
            resolve(NULL)
          } else if (is.null(event)) {
            ## No event, wait and try again
            later_fd(
              handle_stream,
              readfds = fd()$reads,
              timeout = getOption("openaiapi.stream_timeout", 60)
            )
          } else {
            if (is_complete()) {
              reject("Stream is complete before [DONE] event")
            }
            handle_event(event)
            later(handle_stream)
          }
        }
        tryCatch(handle_stream(), error = function(e) reject(e))
      })
    },
    is_complete = function() {
      resp_stream_is_complete(con)
    },
    fd = function() {
      multi_fdset(con$body)
    },
    async = FALSE
  ),
  private = list(
    finalizer = function() {
      close(con)
    },
    con = NULL
  )
)
