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
    stream_async = function(handle_event) {
      promise(function(resolve, reject) {
        read_stream <- function(...) {
          event <- resp_stream_sse(con)
          if (is.null(event)) {
            ## No event, wait and try again
            later_fd(
              read_stream,
              readfds = fd()$reads,
              timeout = getOption("openaiapi.stream_timeout", 60)
            )
          } else if (event$data == "[DONE]") {
            close(con)
            resolve("[DONE]")
          } else if (is_complete()) {
              reject("Stream is complete before [DONE] event")
          } else {
            event$data <- fromJSON(event$data, simplifyVector = FALSE)
            handle_event(event)
            later(read_stream)
          }
        }
        tryCatch(read_stream(), error = function(e) reject(e))
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
