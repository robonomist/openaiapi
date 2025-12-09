# Responses API

- `oai_create_model_response()` - Create a model response.

&nbsp;

- `oai_model_response()` - A helper function to construct a
  ModelResponse or a ModelResponseStream object in R without making an
  API call.

&nbsp;

- `oai_get_model_response()` - Retrieve a model response.

&nbsp;

- `oai_delete_model_response()` - Delete a model response.

&nbsp;

- `oai_list_input_items()` - List input items for a model response.

## Usage

``` r
oai_create_model_response(
  input = NULL,
  model = getOption("openaiapi.model"),
  background = NULL,
  conversation = NULL,
  include = NULL,
  instructions = NULL,
  max_output_tokens = NULL,
  max_tool_calls = NULL,
  metadata = NULL,
  parallel_tool_calls = NULL,
  previous_response_id = NULL,
  prompt = NULL,
  prompt_cache_key = NULL,
  reasoning = NULL,
  safety_identifier = NULL,
  service_tier = NULL,
  store = NULL,
  stream = NULL,
  stream_options = NULL,
  temperature = NULL,
  text = NULL,
  tool_choice = NULL,
  tools = NULL,
  top_logprobs = NULL,
  top_p = NULL,
  truncation = NULL,
  user = NULL,
  verbosity = NULL,
  .classify_response = TRUE,
  .async = FALSE,
  .perform_query = TRUE
)

oai_model_response(
  background = NULL,
  instructions = NULL,
  max_output_tokens = NULL,
  max_tool_calls = NULL,
  metadata = NULL,
  model = getOption("openaiapi.model"),
  parallel_tool_calls = NULL,
  previous_response_id = NULL,
  prompt = NULL,
  prompt_cache_key = NULL,
  reasoning = NULL,
  safety_identifier = NULL,
  service_tier = NULL,
  stream = NULL,
  temperature = NULL,
  text = NULL,
  tool_choice = NULL,
  tools = NULL,
  top_logprobs = NULL,
  top_p = NULL,
  truncation = NULL,
  user = NULL,
  verbosity = NULL,
  .async = FALSE
)

oai_get_model_response(
  response_id,
  include = NULL,
  include_obfuscation = NULL,
  starting_after = NULL,
  stream = FALSE,
  .classify_response = TRUE,
  .async = FALSE
)

oai_delete_model_response(
  response_id,
  .classify_response = TRUE,
  .async = FALSE
)

oai_list_input_items(
  response_id,
  after = NULL,
  before = NULL,
  include = NULL,
  limit = NULL,
  order = NULL,
  .classify_response = TRUE,
  .async = FALSE
)
```

## Arguments

- input:

  Character or List. Text, image, or file inputs to the model, used to
  generate a response.

- model:

  Character. Model ID used to generate the response, like "gpt-4o" or
  "o1".

- background:

  Logical. Whether to run the model response in the background. Defaults
  to `FALSE`.

- conversation:

  Character or list. The conversation that this response belongs to.

- include:

  List. Specify additional output data to include in the model response.

- instructions:

  Character. Inserts a system (or developer) message as the first item
  in the model's context.

- max_output_tokens:

  Integer. An upper bound for the number of tokens that can be generated
  for a response, including visible output tokens and reasoning tokens.

- max_tool_calls:

  Integer. The maximum number of total calls to built-in tools that can
  be processed in a response.

- metadata:

  List. Optional. A named list of at most 16 key-value pairs that can be
  attached to an object. This can be useful for storing additional
  information about the object in a structured format, and querying for
  objects via API or the dashboard.

- parallel_tool_calls:

  Logical. Whether to allow the model to run tool calls in parallel.

- previous_response_id:

  Character. The unique ID of the previous response to the model. Use
  this to create multi-turn conversations.

- prompt:

  List. Reference to a prompt template and its variables.

- prompt_cache_key:

  Character. Used by OpenAI to cache responses for similar requests to
  optimize your cache hit rates. Replaces the `user` field.

- reasoning:

  List. Configuration options for reasoning models.

- safety_identifier:

  Character. A stable identifier used to help detect users of your
  application that may be violating OpenAI's usage policies.

- service_tier:

  Character. The latency tier to use for processing the request. This
  parameter is relevant for customers subscribed to the scale tier
  service.

- store:

  Logical. Whether to store the generated model response for later
  retrieval via API.

- stream:

  Logical. If set to `TRUE`, the function will return a
  `ModelResponseStream` object.

- stream_options:

  List. Options for streaming responses. Only set this when you set
  `stream = TRUE`. It can include `include_obfuscation` to enable stream
  obfuscation.

- temperature:

  Numeric. What sampling temperature to use, between 0 and 2. Higher
  values like 0.8 will make the output more random, while lower values
  like 0.2 will make it more focused and deterministic.

- text:

  List. Configuration options for a text response from the model. Can be
  plain text or structured JSON data.

- tool_choice:

  Character or List. How the model should select which tool (or tools)
  to use when generating a response.

- tools:

  List. An array of tools the model may call while generating a
  response.

- top_logprobs:

  Integer. An integer between 0 and 20 specifying the number of most
  likely tokens to return at each token position, each with an
  associated log probability.

- top_p:

  Numeric. An alternative to sampling with temperature, called nucleus
  sampling, where the model considers the results of the tokens with
  top_p probability mass.

- truncation:

  Character. The truncation strategy to use for the model response.

- user:

  Character. A unique identifier representing your end-user, which can
  help OpenAI to monitor and detect abuse.

- verbosity:

  Character. Constrains the verbosity of the model's response. Lower
  values will result in more concise responses, while higher values will
  result in more verbose responses. Currently supported values are
  "low", "medium", and "high".

- .classify_response:

  Logical. If `TRUE` (default), the response is classified as an R6
  object. If `FALSE`, the response is returned as a list.

- .async:

  Logical. If `TRUE`, the request is performed asynchronously.

- .perform_query:

  Logical. Set to `FALSE` to skip the API call and return a
  ModelResponse or ModelResponseStream object, which can be used to call
  the API later.

- response_id:

  Character. The ID of the response to retrieve input items for.

- include_obfuscation:

  Logical. Whether to include obfuscation in streaming responses.

- starting_after:

  integer. The sequence number of the event after which to start the
  stream.

- after:

  Character. Optional. A cursor for use in pagination. `after` is an
  object ID that defines your place in the list. For instance, if you
  make a list request and receive 100 objects, ending with obj_foo, your
  subsequent call can include `after = "obj_foo"` in order to fetch the
  next page of the list.

- before:

  Character. Optional. A cursor for use in pagination. before is an
  object ID that defines your place in the list. For instance, if you
  make a list request and receive 100 objects, ending with obj_foo, your
  subsequent call can include `before = "obj_foo"` in order to fetch the
  previous page of the list.

- limit:

  Integer. Optional. A limit on the number of objects to be returned.
  Limit can range between 1 and 100, and the default is 20.

- order:

  Character. Optional. Sort order by the created_at timestamp of the
  objects. `"asc"` for ascending order and `"desc"` for descending
  order.

## Value

- `oai_create_model_response()` - A `ModelResponse` object.

&nbsp;

- `oai_model_response()` - A `ModelResponse` or `ModelResponseStream`
  object.

&nbsp;

- `oai_get_model_response()` - A `ModelResponse` object.
