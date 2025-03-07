#' @keywords internal
Utils <- R6Class(
  "Utils",
  portable = FALSE,
  public = list(
    store_response = function(resp) {
      if (is.promise(resp)) {
        p <- resp$then(function(x) {
          store_response(resp = x)
        }) |>
          as_oai_promise()
        return(p)
      }
      self[[".async"]] <- resp[[".async"]]
      for (name in schema$as_is) {
        self[[name]] <- resp[[name]]
      }
      for (name in schema$as_time) {
        self[[name]] <- resp[[name]] |> as_time()
      }
      self
    }
  ),
  private = list(
    schema = list(
      as_is = character(),
      as_time = character()
    )
  )
)
