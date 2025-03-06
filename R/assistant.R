#' Assistant API
#'
#' @description Build assistants that can call models and use tools to perform tasks.
#'
#' @param model Character. ID of the model to use. You can use the `oai_list_models()` to see all of your available models.
#' @param name Character or NULL. Optional. The name of the assistant. The maximum length is 256 characters.
#' @param description Character or NULL. Optional. The description of the assistant. The maximum length is 512 characters.
#' @param instructions Character or NULL. Optional. The system instructions that the assistant uses. The maximum length is 256,000 characters.
#' @param tools List. Optional. Defaults to NULL. A list of tools enabled on the assistant. There can be a maximum of 128 tools per assistant. Tools can be of types code_interpreter, file_search, or function.
#' @param tool_resources List. Optional. A set of resources that are used by the assistant's tools. The resources are specific to the type of tool. For example, the code_interpreter tool requires a list of file IDs, while the file_search tool requires a list of vector store IDs.
#' @param metadata List. Optional. Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format. Keys can be a maximum of 64 characters long and values can be a maximum of 512 characters long.
#' @param temperature Numeric. Optional. Defaults to 1. What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.
#' @param top_p Numeric. Optional. Defaults to 1. An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or temperature but not both.
#' @param response_format Character or List. Optional. Specifies the format that the model must output. Compatible with GPT-4o, GPT-4 Turbo, and all GPT-3.5 Turbo models since gpt-3.5-turbo-1106. Setting to `list(type = "json_object")` enables JSON mode, which guarantees the message the model generates is valid JSON. Important: when using JSON mode, you must also instruct the model to produce JSON yourself via a system or user message. Without this, the model may generate an unending stream of whitespace until the generation reaches the token limit, resulting in a long-running and seemingly "stuck" request. Also note that the message content may be partially cut off if finish_reason="length", which indicates the generation exceeded max_tokens or the conversation exceeded the max context length.
#' @inheritParams common_parameters
#' @return Functions `oai_create_assistant()`, `oai_modify_assistant()`, and `oai_retrieve_assistant()` return an Assistant R6 object.
#' @name assistant_api
NULL

#' @description * `oai_create_assistant()`: Create an assistant with a model and instructions.
#'
#' @rdname assistant_api
#' @export
oai_create_assistant <- function(model,
                                 name = NULL,
                                 description = NULL,
                                 instructions = NULL,
                                 tools = NULL,
                                 tool_resources = NULL,
                                 metadata = NULL,
                                 temperature = NULL,
                                 top_p = NULL,
                                 response_format = NULL,
                                 .classify_response = TRUE) {
  body <- list(
    model = model,
    name = name,
    description = description,
    instructions = instructions,
    tools = tools,
    tool_resources = tool_resources,
    metadata = metadata,
    temperature = temperature,
    top_p = top_p,
    response_format = response_format
  ) |> compact()
  oai_query(
    ep = "assistants",
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response
  )
}

#' @description * `oai_modify_assistant()`: Modify an assistant's properties.
#' @param assistant_id Character. The ID of the assistant to modify.
#' @rdname assistant_api
#' @export
oai_modify_assistant <- function(assistant_id,
                                 model = NULL,
                                 name = NULL,
                                 description = NULL,
                                 instructions = NULL,
                                 tools = NULL,
                                 tool_resources = NULL,
                                 metadata = NULL,
                                 temperature = NULL,
                                 top_p = NULL,
                                 response_format = NULL,
                                 .classify_response = TRUE) {
  body <- list(
    model = model,
    name = name,
    description = description,
    instructions = instructions,
    tools = tools,
    tool_resources = tool_resources,
    metadata = metadata,
    temperature = temperature,
    top_p = top_p,
    response_format = response_format
  ) |> compact()
  oai_query(
    c("assistants", assistant_id),
    headers = openai_beta_header(),
    body = body,
    method = "POST",
    .classify_response = .classify_response
  )
}

#' @description * `oai_list_assistants()`: List all assistants.
#' @rdname assistant_api
#' @return Function `oai_list_assistants()` returns a list of Assistant R6 objects.
#' @export
oai_list_assistants <- function(limit = NULL,
                                order = NULL,
                                after = NULL,
                                before = NULL,
                                .classify_response = TRUE) {
  query <- list(
    limit = as.integer(limit),
    order = order,
    after = after,
    before = before
  ) |> compact()
  oai_query_list(
    "assistants",
    headers = openai_beta_header(),
    method = "GET",
    query = query,
    .classify_response = .classify_response
  )
}

#' @description * `oai_retrieve_assistant()`: Retrieve an assistant.
#' @param assistant_id Character. The ID of the assistant to retrieve.
#' @rdname assistant_api
#' @export
oai_retrieve_assistant <- function(assistant_id, .classify_response = TRUE) {
  oai_query(
    c("assistants", assistant_id),
    headers = openai_beta_header(),
    .classify_response = .classify_response
  )
}

#' @description * `oai_delete_assistant()`: Delete an assistant.
#' @rdname assistant_api
#' @return Function `oai_delete_assistant()` returns the deletion status.
#' @export
oai_delete_assistant <- function(assistant_id) {
  oai_query(
    c("assistants", assistant_id),
    headers = openai_beta_header(),
    method = "DELETE"
  )
}

#' Assistant R6 class
#'
#' @description This class provides methods to interact with the OpenAI Assistant API.
#'
#' @param assistant_id Character. The ID of the assistant to retrieve.
#' @param model Character. ID of the model to use. You can use the `oai_list_models()` to see all of your available models.
#' @param resp List. The assistant's properties from the API response.
#' @param ... Additional arguments passed to the `oai_*_assistant()` functions.
#' @importFrom R6 R6Class
#' @export
Assistant <- R6Class(
  "Assistant",
  portable = FALSE,
  public = list(
    #' @description Initializes the OpenAI Assistant object. You must provide either an assistant ID or a model. If you provide an assistant ID, the assistant is retrieved from the API. If you provide a model, a new assistant is created, and `...` argument is used to pass additional arguments to the `oai_create_assistant()` function.
    #' @return An instance of the OpenAI_Assistant class.
    initialize = function(assistant_id = NULL,
                          model = NULL,
                          ...,
                          resp = NULL) {
      if (!is.null(assistant_id)) {
        id <<- assistant_id
        self$retrieve()
      } else if (!is.null(model)) {
        args <- list(model = model, ...)
        args$.classify_response <- FALSE
        do.call(oai_create_assistant, args) |> initialize(resp = _)
      } else if (!is.null(resp)) {
        id <<- resp$id
        created_at <<- resp$created_at |> as_time()
        name <<- resp$name
        description <<- resp$description
        model <<- resp$model
        instructions <<- resp$instructions
        tools <<- resp$tools
        tool_resources <<- resp$tool_resources
        metadata <<- resp$metadata
        temperature <<- resp$temperature
        top_p <<- resp$top_p
        response_format <<- resp$response_format
      } else {
        stop("You must provide either a model or a response object.")
      }
    },
    #' @field id The ID of the assistant.
    id = NULL,
    #' @field created_at The creation time of the assistant.
    created_at = NULL,
    #' @field name The name of the assistant.
    name = NULL,
    #' @field description The description of the assistant.
    description = NULL,
    #' @field model ID of the model to use. You can use the `oai_list_models()` function to see all of your available models.
    model = NULL,
    #' @field instructions The system instructions that the assistant uses.
    instructions = NULL,
    #' @field tools A list of tool enabled on the assistant.
    tools = NULL,
    #' @field tool_resources A set of resources that are used by the assistant's tools.
    tool_resources = NULL,
    #' @field metadata Set of 16 key-value pairs that can be attached to an object.
    metadata = NULL,
    #' @field temperature Sampling temperature.
    temperature = NULL,
    #' @field top_p An alternative to sampling with temperature, called nucleus sampling.
    top_p = NULL,
    #' @field response_format The response format of the assistant.
    response_format = NULL,
    #' @description Modify the assistant's properties. The `...` argument is used to pass additional arguments to the `oai_modify_assistant()` function.
    modify = function(...) {
      args <- list(...)
      args$assistant_id <- self$id
      args$.classify_response <- FALSE
      do.call(oai_modify_assistant, args) |> initialize(resp = _)
      self
    },
    #' @description Retrieve the assistant's properties from the API.
    #'
    #' @return The up-to-date version of OpenAI_Assistant instance.
    retrieve = function() {
      oai_retrieve_assistant(
        assistant_id = self$id, .classify_response = FALSE
      ) |>
        initialize(resp = _)
      self
    },
    #' Delete the assistant
    #' @return Deletion status
    delete = function() {
      oai_delete_assistant(assistant_id = self$id)
    },
    #' Print the assistant's details
    #'
    #' @param ... Additional arguments (unused).
    #' @return The OpenAI_Assistant instance.
    print = function(...) {
      cat("Assistant:\n")
      cat("id: ", self$id, "\n")
      cat("name: ", self$name, "\n")
      invisible(self)
    },
    #' Create a thread and run the assistant
    #'
    #' @param thread An oai_thread object.
    #' @param ... Additional arguments passed to `oai_create_thread_and_run()`.
    #' @return The response from the thread creation and run.
    thread_and_run = function(thread = NULL, ...) {
      oai_create_thread_and_run(
        assistant_id = self$id,
        thread = thread,
        ...
      )
    }
  )
)
