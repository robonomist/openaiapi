#' Set OpenAI API
#'
#' @param api_key A character string with the OpenAI API key.
#' @export
oai_set_api_key <- function(api_key) {
  options(openaiapi.api_key = api_key)
}

#' @keywords internal
openai_beta_header <- function() {
  version <- getOption("openaiapi.assistants.version", "v2")
  list(`OpenAI-Beta` = paste0("assistants=", version))
}

#' @keywords internal
oai_request <- function(ep, body, method, headers) {
  request("https://api.openai.com/v1") |>
    req_url_path_append(ep) |>
    req_headers(
      Authorization = paste("Bearer", getOption("openaiapi.api_key")),
      !!!headers
    ) |>
    req_method(method) |>
    req_error(body = oai_error_body)
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

#' @keywords internal
oai_query <- function(ep,
                      body = NULL,
                      query = NULL,
                      method = "GET",
                      encode = "json",
                      headers = NULL,
                      path = NULL,
                      .classify_response = TRUE) {
  ## Body can not a empty list
  body <- if (length(body)) body
  ## Iterate lists if query limit is set to more than 100
  iterate_list <-
    if (!is.null(query$limit) && query$limit > 100) {
      limit <- query$limit
      query$limit <- 100
      TRUE
    } else {
      FALSE
    }
  req <-
    oai_request(ep, body, method, headers)
  if (!is.null(body) && encode == "json") {
    req <- req_body_json(req, body, force = TRUE)
  } else if (encode == "multipart") {
    req <- req_body_multipart(req, !!!body)
  }
  resp <- req_perform(req, path = path)
  if (iterate_list) {
    resp <- resp_body_json(resp)
    need_more <- length(resp$data) < limit && resp$has_more
    while (need_more) {
      next_resp <-
        req |>
        req_url_query(
          after = resp$last_id,
          limit = min(100, limit - length(resp$data))
        ) |>
        req_perform() |>
        resp_body_json()
      resp$data <- append(resp$data, next_resp$data)
      resp$last_id <- next_resp$last_id
      resp$has_more <- next_resp$has_more
      need_more <- length(resp$data) < limit && next_resp$has_more
    }
  }
  if (is.null(.classify_response)) {
    resp
  } else if (.classify_response) {
    resp_body_json(resp) |> classify_response()
  } else {
    resp_body_json(resp)
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
