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
oai_request <- function(ep, body, query, method, headers, encode) {
  ## Body can not a empty list
  query <- compact(query)
  req <-
    request("https://api.openai.com/v1") |>
    req_url_path_append(ep) |>
    req_url_query(!!!query) |>
    req_headers(
      Authorization = paste("Bearer", getOption("openaiapi.api_key")),
      !!!headers
    ) |>
    req_method(method) |>
    req_error(body = oai_error_body)
  if (!is.null(body) && encode == "json") {
    body <- compact(body)
    body <- if (length(body)) body else NULL
    req <- req_body_json(req, body, force = TRUE, null = "list")
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
                      .stream_class = NULL) {
  req <- oai_request(ep, body, query, method, headers, encode)

  if (isTRUE(body$stream)) {
    ## STREAMING -------------------------------------------------
    handle_stream <- function() {
      con <- req_perform_connection(req, blocking = !.async)
      s <- StreamReader$new(con, .async = .async)
      if (.classify_response) {
        s <- classify_stream(s, .stream_class)
      }
      s
    }
    if (.async) {
      ## Handle async streaming case
      p <- promise(function(resolve, reject) {
        later(function() {
          ## TODO: This should be made a promise that resolves when the connection is established
          tryCatch(resolve(handle_stream()), error = function(e) reject(e))
        })
      }) |>
        as_oai_promise()
      return(p)
    } else {
      ## Handle sync streaming case
      return(handle_stream())
    }
  } else {
    ## NON-STREAMING ----------------------------------------------
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
        then(
          onFulfilled = handle_response,
          onRejected = ~ cli_abort("Failed to perform request", parent = .x)
        ) |>
        as_oai_promise()
    } else {
      ## Handle sync non-streaming case
      req_perform(req, path = path) |>
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
oai_query_list <- function(..., .classify_response = TRUE, .async = FALSE) {

  args <-
    list(..., .classify_response = .classify_response, .async = .async) |>
    compact()

  fetch_page <- function() {
    do.call(oai_query, args)
  }

  if (!.classify_response) {
    return(fetch_page())
  }

  requested_limit <- args$query$limit %||% 100
  args$query$limit <- min(100, requested_limit)

  combine_pages <- function(old, new) {
    combined <- append(old, new)
    attr(combined, "last_id") <- attr(new, "last_id")
    attr(combined, "has_more") <- attr(new, "has_more")
    combined
  }

  need_more <- function(page) {
    n <- length(page)
    has_more <- attr(page, "has_more")
    n < requested_limit && has_more
  }

  page <- fetch_page()

  if (!.async) {
    while (need_more(page)) {
      args$query$after <- attr(page, "last_id")
      args$query$limit <- min(100, requested_limit - length(page))
      next_page <- fetch_page()
      page <- combine_pages(page, next_page)
    }
    return(page)
  } else {
    paginate_async <- function(page) {
      if (need_more(page)) {
        args$query$after <<- attr(page, "last_id")
        args$query$limit <<- min(100, requested_limit - length(page))
        fetch_page()$then(function(next_page) {
          combine_pages(page, next_page)
        })$then(paginate_async)
      } else {
        page
      }
    }
    page$then(paginate_async)
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
  if (is.null(x$object)) {
    return(x)
  }
  switch(
    x$object,
    "list" = oai_list(x),
    "response" = ModelResponse$new(resp = x),
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

classify_stream <- function(x, .stream_class = NULL) {
  switch(
    .stream_class,
    "ModelResponse" = ModelResponseStream$new(x),
    "ChatCompletion" = ChatCompletionStream$new(x),
    "Run" = RunStream$new(x),
    x
  )
}

