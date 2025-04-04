#' Define a function tool
#'
#' @param name The name of the function being called. The function name must be a-z, A-Z, 0-9, or contain underscores and dashes, with a maximum length of 64. The model's function call will be handled by calling a function with this name in R.
#' @param description A description of what the function does, used by the model to choose when and how to call the function.
#' @param ... A list of parameters the function accepts. Use `oai_function_tool_parameter` to define each parameter.
#' @param strict Whether to enable strict schema adherence when generating the function call. If set to true, the model will follow the exact schema defined in the parameters field.
#' @param parameters Parameters can be given alternatively a list of `oai_function_tool_parameter` objects.
#' @rdname oai_function_tool
#' @export
oai_function_tool <- function(name,
                              description = NULL,
                              ...,
                              parameters = NULL,
                              strict = TRUE) {

  parameters <- append(parameters, list(...))

  .parameters <- if (length(parameters)) {
    properties <- lapply(parameters, function(p) {
      p$required <- NULL
      p$name <- NULL
      p
    })
    names(properties) <-
      sapply(parameters, function(p) p$name)
    required <-
      names(properties)[sapply(parameters, function(p) p$required)]
    list(
      type = "object",
      properties = properties,
      required = I(required),
      additionalProperties = FALSE
    ) |> compact()
  }

  list(
    type = "function",
    `function` = list(
      description = description,
      name = name,
      parameters = .parameters,
      strict = strict
    ) |>
      compact()
  ) |>
    structure(class = "oai_function_tool")
}

#' Create a function tool parameter for `oai_function_tool`
#'
#' @param name The name of the parameter.
#' @param type The type of the parameter. Possible values are "string", "number", "boolean", "array", "object", and "null".
#' @param description A description of the parameter.
#' @param required Whether the parameter is required or optional.
#' @param enum A list of possible values for the parameter.
#' @param ... Additional properties to be added to the parameter.
#' @rdname oai_function_tool
#' @export
oai_function_tool_parameter <- function(name,
                                        type,
                                        description,
                                        required = TRUE,
                                        enum = NULL,
                                        ...) {
  list(
    name = name,
    type = type,
    description = description,
    required = required,
    enum = enum,
    ...
  ) |> compact()
}
