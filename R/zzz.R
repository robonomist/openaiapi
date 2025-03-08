.onLoad <- function(...) {
  set_defaults()
  ## if (is.null(getOption("openaiapi.api_key")) &&
  ##       nzchar(api_key <- Sys.getenv("OPENAI_API_KEY"))) {
  ##   options(openaiapi.api_key = api_key)
  ## }
}


#' @keywords internal
set_defaults <- function() {
  op <- options()
  openaiapi_defaults <- list(
    openaiapi.api_key = Sys.getenv("OPENAI_API_KEY"),
    openaiapi.assistants_version = "v2",
    openaiapi.run_timeout = 300,
    openaiapi.run_poll_interval = 1
  )
  to_set <- setdiff(names(openaiapi_defaults), names(op))
  if (length(to_set)) {
    options(openaiapi_defaults[to_set])
  }
}
