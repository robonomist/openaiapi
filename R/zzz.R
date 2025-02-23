.onLoad <- function(...) {
  if (is.null(getOption("openaiapi.api_key")) &&
        nzchar(api_key <- Sys.getenv("OPENAI_API_KEY"))) {
    options(openaiapi.api_key = api_key)
  }
}
