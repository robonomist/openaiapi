#' @importFrom jsonlite fromJSON
#' @importFrom curl multi_fdset
#' @importFrom later later later_fd
#' @keywords internal
StreamReader <- R6Class(
  "StreamReader",
  portable = FALSE,
  cloneable = FALSE,
  public = list(
    initialize = function(con, .async = FALSE) {
      async <<- .async
      con <<- con
    },
    stream_async = function(handle_event) {
      promise(function(resolve, reject) {
        read_stream <- function(time_left = TRUE, ...) {
          if (!time_left) {
            close(con)
            reject("Timeout")
            return(NULL)
          }
          tryCatch(
            {
              event <- resp_stream_sse(con)
              if (is_complete()) {
                close(con)
                resolve("[COMPLETE]")
              } else if (is.null(event)) {
                ## No event, wait and try again
                later_fd(
                  read_stream,
                  readfds = fd()$reads,
                  timeout = getOption("openaiapi.stream_timeout", 60)
                )
              } else if (event$data == "[DONE]") {
                close(con)
                resolve("[DONE]")
              } else {
                event$data <- fromJSON(event$data, simplifyVector = FALSE)
                handle_event(event)
                later(read_stream)
              }
            },
            error = function(e) reject(e)
          )
        }
        read_stream()
      })
    },
    stream_sync = function(handle_event) {
      repeat {
        event <- resp_stream_sse(con)
        if (is.null(event)) {
          Sys.sleep(0.1)
        } else if (event$data == "[DONE]" || is_complete()) {
          close(con)
          return("[DONE]")
        } else {
          event$data <- fromJSON(event$data, simplifyVector = FALSE)
          handle_event(event)
        }
      }
    },
    generator = function() {
      coro::gen({
        repeat {
          event <- resp_stream_sse(con)
          if (is.null(event)) {
            Sys.sleep(0.1)
            ## yield("")
          } else if (event$data == "[DONE]" || is_complete()) {
            close(con)
            return("[DONE]")
          } else {
            data <- fromJSON(event$data, simplifyVector = FALSE)
            yield(data$delta)
          }
        }
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
      if (!is.null(con) && !isOpen(con)) {
        try(close(con))
      }
    },
    con = NULL
  )
)
