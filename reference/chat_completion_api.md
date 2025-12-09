# Chat completion API

- `oai_create_chat_completion()`: Create a chat completion.\`

&nbsp;

- `oai_get_chat_completion()`: Get a stored chat completion.

&nbsp;

- `oai_get_chat_messages()`: Get the messages in a stored chat
  completion.

&nbsp;

- `oai_list_chat_completions()`: List stored chat completions.

&nbsp;

- `oai_update_chat_completion()`: Update a stored chat completion.

&nbsp;

- `oai_delete_chat_completion()`: Delete a stored chat completion. Only
  chat completions that have been created with the store parameter set
  to true can be deleted.

## Usage

``` r
oai_create_chat_completion(
  messages,
  model = getOption("openaiapi.model"),
  frequency_penalty = NULL,
  logit_bias = NULL,
  logprobs = NULL,
  top_logprobs = NULL,
  max_tokens = NULL,
  n = NULL,
  presence_penalty = NULL,
  response_format = NULL,
  seed = NULL,
  service_tier = NULL,
  stop = NULL,
  stream = NULL,
  stream_options = NULL,
  temperature = NULL,
  top_p = NULL,
  tools = NULL,
  tools_choice = NULL,
  parallel_tool_calls = NULL,
  user = NULL,
  web_search_options = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_get_chat_completion(
  completion_id,
  .classify_response = TRUE,
  .async = FALSE
)

oai_get_chat_messages(
  completion_id,
  after = NULL,
  limit = NULL,
  order = NULL,
  .async = FALSE
)

oai_list_chat_completions(
  model = NULL,
  metadata = NULL,
  after = NULL,
  limit = NULL,
  order = NULL
)

oai_update_chat_completion(
  completion_id,
  metadata,
  .classify_response = TRUE,
  .async = FALSE
)

oai_delete_chat_completion(completion_id, .async = FALSE)
```

## Arguments

- messages:

  A list of messages comprising the conversation so far. You can also
  pass a oai_message object or a character vector.

- model:

  The model used to generate the chat completions.

- frequency_penalty:

  Numeric. Number between -2.0 and 2.0. Positive values penalize new
  tokens based on their existing frequency in the text so far,
  decreasing the model's likelihood to repeat the same line verbatim.

- logit_bias:

  List. Modify the likelihood of specified tokens appearing in the
  completion.

- logprobs:

  Logical. Whether to return log probabilities of the output tokens or
  not. If true, returns the log probabilities of each output token
  returned in the content of message.

- top_logprobs:

  Integer. An integer between 0 and 20 specifying the number of most
  likely tokens to return at each token position, each with an
  associated log probability. logprobs must be set to true if this
  parameter is used.

- max_tokens:

  Integer. The maximum number of tokens that can be generated in the
  chat completion.

- n:

  Integer. How many chat completion choices to generate for each input
  message. Note that you will be charged based on the number of
  generated tokens across all of the choices. Keep n as 1 to minimize
  costs.

- presence_penalty:

  Numeric. Number between -2.0 and 2.0. Positive values penalize new
  tokens based on whether they appear in the text so far, increasing the
  model's likelihood to talk about new topics.

- response_format:

  List. An object specifying the format that the model must output.
  Compatible with GPT-4o, GPT-4o mini, GPT-4 Turbo and all GPT-3.5 Turbo
  models newer than gpt-3.5-turbo-1106.

- seed:

  Integer. If specified, our system will make a best effort to sample
  deterministically, such that repeated requests with the same seed and
  parameters should return the same result. Determinism is not
  guaranteed, and you should refer to the system_fingerprint response
  parameter to monitor changes in the backend.

- service_tier:

  Character. Specifies the latency tier to use for processing the
  request. This parameter is relevant for customers subscribed to the
  scale tier service.

- stop:

  Character. Up to 4 sequences where the API will stop generating
  further tokens.

- stream:

  Logical. If set, partial message deltas will be sent, like in ChatGPT.
  Tokens will be sent as data-only server-sent events as they become
  available, with the stream terminated by a data.

- stream_options:

  List. Options for streaming response. Only set this when you set
  `stream = TRUE`.

- temperature:

  Numeric. What sampling temperature to use, between 0 and 2. Higher
  values like 0.8 will make the output more random, while lower values
  like 0.2 will make it more focused and deterministic.

- top_p:

  Numeric. An alternative to sampling with temperature, called nucleus
  sampling, where the model considers the results of the tokens with
  top_p probability mass. So 0.1 means only the tokens comprising the
  top 10% probability mass are considered.

- tools:

  List. A list of tools the model may call. Currently, only functions
  are supported as a tool. Use this to provide a list of functions the
  model may generate JSON inputs for. A max of 128 functions are
  supported.

- tools_choice:

  Character. Controls which (if any) tool is called by the model. "none"
  means the model will not call any tool and instead generates a
  message. "auto" means the model can pick between generating a message
  or calling one or more tools. "required" means the model must call one
  or more tools. Specifying a particular tool via
  `list(type = "function", function = list(name = "my_function"))`
  forces the model to call that tool. "none" is the default when no
  tools are present. "auto" is the default if tools are present.

- parallel_tool_calls:

  Logical. Whether to enable parallel function calling during tool use.

- user:

  Character. A unique identifier representing your end-user, which can
  help OpenAI to monitor and detect abuse.

- web_search_options:

  List. This tool searches the web for relevant results to use in a
  response.

- .classify_response:

  Logical. If `TRUE` (default), the response is classified as an R6
  object. If `FALSE`, the response is returned as a list.

- .async:

  Logical. If `TRUE`, the request is performed asynchronously.

- completion_id:

  The ID of the chat completion to delete.

- after:

  Identifier for the last chat completion from the previous pagination
  request.

- limit:

  Number of chat completions to retrieve.

- order:

  Sort order for chat completions by timestamp. Use asc for ascending
  order or desc for descending order. Defaults to asc.

- metadata:

  List. Optional. A named list of at most 16 key-value pairs that can be
  attached to an object. This can be useful for storing additional
  information about the object in a structured format, and querying for
  objects via API or the dashboard.

## Value

A ChatCompletion R6 object.

`oai_get_chat_messages()` returns a list of messages in the chat
completion.

`oai_list_chat_completions()` returns a list of ChatCompletion objects.

`oai_delete_chat_completion()` returns a deletion confirmation object.

## Details

Only chat completions that have been created with the store parameter
set to true will be returned.
