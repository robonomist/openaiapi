#' Models API
#'
#' List and describe the various models available in the API.
#'
#' @name models_api
NULL

#' @description * `oai_list_models()`: Retrieve a data frame of models.
#' @export
#' @return  of models
#' @rdname models_api
oai_list_models <- function() {
  m <- oai_query("models")
  cols <- c("id", "object", "created", "owned_by")
  y <- lapply(cols, function(i) {
    sapply(m, function(x) x[[i]])
  })
  names(y) <- cols
  y$created <- as_time(y$created)
  class(y) <- c("tbl_df", "tbl", "data.frame")
  attr(y, "row.names") <- seq_len(length(m))
  y
}

#' @description * `oai_retrieve_model()`: Retrieve a model.
#' @export
#' @param model_id Character. The ID of the model to retrieve/delete.
#' @rdname models_api
oai_retrieve_model <- function(model_id) {
  oai_query(
    ep = c("models", model_id),
    method = "GET"
  )
}

#' @description * `oai_delete_model()`: Delete a model.
#' @export
#' @rdname models_api
oai_delete_model <- function(model_id) {
  oai_query(
    ep = c("models", model_id),
    method = "DELETE"
  )
}

