#' @keywords internal
Utils <- R6Class(
  "Utils",
  portable = FALSE,
  public = list(
    .async = FALSE
  ),
  private = list(
    store_response = function(resp) {
      if (is.promise(resp)) {
        resp$then(function(x) {
          store_response(resp = x)
        }) |>
          as_oai_promise()
      } else {
        self[[".async"]] <- resp[[".async"]] %||% self[[".async"]]
        ## Store the response in the object according to the schema
        resp <- compact(resp)
        for (name in schema$as_is) {
          self[[name]] <- resp[[name]]
        }
        for (name in schema$as_time) {
          self[[name]] <- resp[[name]] |> as_time()
        }
        for (name in schema$unlist) {
          self[[name]] <- resp[[name]] |> unlist(use.names = FALSE)
        }
        self
      }
    },
    .print = function(...) {
      cli_h1(class(self)[1])
      cli_dl(c(...))
      invisible(self)
    },
    schema = list(
      as_is = character(),
      as_time = character(),
      unlist = character()
    )
  )
)
