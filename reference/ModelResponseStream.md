# ModelResponseStream R6 Class

ModelResponseStream R6 Class

ModelResponseStream R6 Class

## Super classes

`openaiapi::Utils` -\>
[`openaiapi::ModelResponse`](https://robonomist.github.io/openaiapi/reference/ModelResponse.md)
-\> `ModelResponseStream`

## Methods

### Public methods

- [`ModelResponseStream$new()`](#method-ModelResponseStream-new)

- [`ModelResponseStream$stream()`](#method-ModelResponseStream-stream)

- [`ModelResponseStream$generator()`](#method-ModelResponseStream-generator)

- [`ModelResponseStream$async_generator()`](#method-ModelResponseStream-async_generator)

- [`ModelResponseStream$clone()`](#method-ModelResponseStream-clone)

Inherited methods

- [`openaiapi::ModelResponse$await()`](https://robonomist.github.io/openaiapi/reference/ModelResponse.html#method-await)
- [`openaiapi::ModelResponse$delete()`](https://robonomist.github.io/openaiapi/reference/ModelResponse.html#method-delete)
- [`openaiapi::ModelResponse$do_tool_calls()`](https://robonomist.github.io/openaiapi/reference/ModelResponse.html#method-do_tool_calls)
- [`openaiapi::ModelResponse$get()`](https://robonomist.github.io/openaiapi/reference/ModelResponse.html#method-get)
- [`openaiapi::ModelResponse$list_input_items()`](https://robonomist.github.io/openaiapi/reference/ModelResponse.html#method-list_input_items)
- [`openaiapi::ModelResponse$respond()`](https://robonomist.github.io/openaiapi/reference/ModelResponse.html#method-respond)
- [`openaiapi::ModelResponse$submit_tool_outputs()`](https://robonomist.github.io/openaiapi/reference/ModelResponse.html#method-submit_tool_outputs)
- [`openaiapi::ModelResponse$wait()`](https://robonomist.github.io/openaiapi/reference/ModelResponse.html#method-wait)

------------------------------------------------------------------------

### Method `new()`

Initialize a `ModelResponseStream` object.

#### Usage

    ModelResponseStream$new(stream_reader = NULL, init = NULL)

#### Arguments

- `stream_reader`:

  StreamReader. The stream reader object.

- `init`:

  List. The initial response object.

------------------------------------------------------------------------

### Method `stream()`

Stream the model response.

#### Usage

    ModelResponseStream$stream(
      on_event = function(event) {
     },
      on_output_text = function(output_text) {
     },
      on_output_text_delta = function(data) {
     },
      env = parent.frame()
    )

#### Arguments

- `on_event`:

  Function. Callback function to handle all events. The function should
  accept a single argument, `event`, which is a list containing the
  event `type` and `data`.

- `on_output_text`:

  Function. Callback function to handle event that change output text.
  The function should accept a single argument containing the output
  text string.

- `on_output_text_delta`:

  Function. Callback function to handle output text delta events. The
  function should accept a single argument containing the delta event
  data.

- `env`:

  Environment. The environment in which to evaluate the tool calls.

------------------------------------------------------------------------

### Method `generator()`

Get the generator function for the stream.

#### Usage

    ModelResponseStream$generator(
      on_event = function(event) {
     },
      on_output_text = function(output_text) {
     },
      on_output_text_delta = function(data) {
     },
      env = parent.frame()
    )

#### Arguments

- `on_event`:

  Function. Callback function to handle all events. The function should
  accept a single argument, `event`, which is a list containing the
  event `type` and `data`.

- `on_output_text`:

  Function. Callback function to handle event that change output text.
  The function should accept a single argument containing the output
  text string.

- `on_output_text_delta`:

  Function. Callback function to handle output text delta events. The
  function should accept a single argument containing the delta event
  data.

- `env`:

  Environment. The environment in which to evaluate the tool calls.

#### Returns

A coro package generator function.

------------------------------------------------------------------------

### Method `async_generator()`

Get the async generator function for the stream.

#### Usage

    ModelResponseStream$async_generator(
      on_event = function(event) {
     },
      on_output_text = function(output_text) {
     },
      on_output_text_delta = function(data) {
     },
      env = parent.frame()
    )

#### Arguments

- `on_event`:

  Function. Callback function to handle all events. The function should
  accept a single argument, `event`, which is a list containing the
  event `type` and `data`.

- `on_output_text`:

  Function. Callback function to handle event that change output text.
  The function should accept a single argument containing the output
  text string.

- `on_output_text_delta`:

  Function. Callback function to handle output text delta events. The
  function should accept a single argument containing the delta event
  data.

- `env`:

  Environment. The environment in which to evaluate the tool calls.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    ModelResponseStream$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
