# Run R6 class

Run R6 class

Run R6 class

RunStream R6 class

RunStream R6 class

## Super class

`openaiapi::Utils` -\> `Run`

## Public fields

- `id`:

  Run ID.

- `created_at`:

  Time the run was created.

- `thread_id`:

  Thread ID.

- `assistant_id`:

  Assistant ID.

- `status`:

  Run status.

- `required_action`:

  Required action.

- `last_error`:

  Last error.

- `started_at`:

  Time the run was started.

- `expires_at`:

  Time the run expires.

- `cancelled_at`:

  Time the run was cancelled.

- `failed_at`:

  Time the run failed.

- `completed_at`:

  Time the run was completed.

- `incomplete_details`:

  Incomplete details.

- `model`:

  Model.

- `instructions`:

  Instructions.

- `tools`:

  Tools.

- `metadata`:

  Metadata.

- `usage`:

  Usage.

- `temperature`:

  Temperature.

- `top_p`:

  Top p.

- `max_prompt_tokens`:

  Maximum prompt tokens.

- `max_completion_tokens`:

  Maximum completion tokens.

- `truncation_strategy`:

  Truncation strategy.

- `tool_choice`:

  Tool choice.

- `response_format`:

  Response format.

## Methods

### Public methods

- [`Run$new()`](#method-Run-new)

- [`Run$list_steps()`](#method-Run-list_steps)

- [`Run$retrieve()`](#method-Run-retrieve)

- [`Run$retrieve_status()`](#method-Run-retrieve_status)

- [`Run$modify()`](#method-Run-modify)

- [`Run$cancel()`](#method-Run-cancel)

- [`Run$submit_tool_outputs()`](#method-Run-submit_tool_outputs)

- [`Run$wait()`](#method-Run-wait)

- [`Run$await()`](#method-Run-await)

- [`Run$do_tool_calls()`](#method-Run-do_tool_calls)

- [`Run$thread()`](#method-Run-thread)

- [`Run$assistant()`](#method-Run-assistant)

- [`Run$clone()`](#method-Run-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize a Run object. If `thread_id` and `run_id` are provided, the
Run object is initialized with the corresponding run. If `thread_id` and
`assistant_id` are provided, a new run is created.

#### Usage

    Run$new(
      thread_id = NULL,
      run_id = NULL,
      assistant_id = NULL,
      ...,
      resp = NULL,
      .async = FALSE
    )

#### Arguments

- `thread_id`:

  Thread ID or Thread object

- `run_id`:

  Run ID.

- `assistant_id`:

  Assistant ID or Assistant object.

- `...`:

  Additional arguments passed to the API function.

- `resp`:

  Response object.

- `.async`:

  Logical. If TRUE, the API call will be asynchronous.

------------------------------------------------------------------------

### Method `list_steps()`

Retrieve the run. The `...` argument is passed to
`oai_list_run steps()`.

#### Usage

    Run$list_steps(...)

#### Arguments

- `...`:

  Additional arguments passed to the API function.

#### Returns

`list_steps()` returns a list of `RunStep` objects.

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve the run.

#### Usage

    Run$retrieve()

------------------------------------------------------------------------

### Method `retrieve_status()`

Retrieve the up-to-date status of the run.

#### Usage

    Run$retrieve_status()

------------------------------------------------------------------------

### Method `modify()`

Modify the metadata of the run.

#### Usage

    Run$modify(...)

#### Arguments

- `...`:

  Additional arguments passed to the API function.

------------------------------------------------------------------------

### Method `cancel()`

Cancel the run.

#### Usage

    Run$cancel()

------------------------------------------------------------------------

### Method `submit_tool_outputs()`

Submit tool outputs.

#### Usage

    Run$submit_tool_outputs(tool_outputs, stream = NULL)

#### Arguments

- `tool_outputs`:

  Tool outputs.

- `stream`:

  Logical. If TRUE, the function will return a RunStream object.

------------------------------------------------------------------------

### Method `wait()`

Wait for the run to complete.

#### Usage

    Run$wait(env = parent.frame())

#### Arguments

- `env`:

  Environment to evaluate tool calls.

------------------------------------------------------------------------

### Method `await()`

Perform tool calls asynchronously. Returns a promise.

#### Usage

    Run$await(env = parent.frame())

#### Arguments

- `env`:

  Environment to evaluate tool calls.

------------------------------------------------------------------------

### Method `do_tool_calls()`

Perform tool calls. Returns a list of tool outputs.

#### Usage

    Run$do_tool_calls(env = parent.frame())

#### Arguments

- `env`:

  Environment to evaluate tool calls.

------------------------------------------------------------------------

### Method `thread()`

Retrieve the thread of the run.

#### Usage

    Run$thread()

------------------------------------------------------------------------

### Method `assistant()`

Retrieve the assistant of the run.

#### Usage

    Run$assistant()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Run$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Super classes

`openaiapi::Utils` -\> `openaiapi::Run` -\> `RunStream`

## Public fields

- `event_data`:

  Data accumulated from the event stream.

## Methods

### Public methods

- [`RunStream$new()`](#method-RunStream-new)

- [`RunStream$stream_async()`](#method-RunStream-stream_async)

- [`RunStream$clone()`](#method-RunStream-clone)

Inherited methods

- [`openaiapi::Run$assistant()`](https://robonomist.github.io/openaiapi/reference/Run.html#method-assistant)
- [`openaiapi::Run$await()`](https://robonomist.github.io/openaiapi/reference/Run.html#method-await)
- [`openaiapi::Run$cancel()`](https://robonomist.github.io/openaiapi/reference/Run.html#method-cancel)
- [`openaiapi::Run$do_tool_calls()`](https://robonomist.github.io/openaiapi/reference/Run.html#method-do_tool_calls)
- [`openaiapi::Run$list_steps()`](https://robonomist.github.io/openaiapi/reference/Run.html#method-list_steps)
- [`openaiapi::Run$modify()`](https://robonomist.github.io/openaiapi/reference/Run.html#method-modify)
- [`openaiapi::Run$retrieve()`](https://robonomist.github.io/openaiapi/reference/Run.html#method-retrieve)
- [`openaiapi::Run$retrieve_status()`](https://robonomist.github.io/openaiapi/reference/Run.html#method-retrieve_status)
- [`openaiapi::Run$submit_tool_outputs()`](https://robonomist.github.io/openaiapi/reference/Run.html#method-submit_tool_outputs)
- [`openaiapi::Run$thread()`](https://robonomist.github.io/openaiapi/reference/Run.html#method-thread)
- [`openaiapi::Run$wait()`](https://robonomist.github.io/openaiapi/reference/Run.html#method-wait)

------------------------------------------------------------------------

### Method `new()`

Initialize a RunStream object.

#### Usage

    RunStream$new(stream_reader)

#### Arguments

- `stream_reader`:

  StreamReader object.

------------------------------------------------------------------------

### Method `stream_async()`

Stream the run asynchronously.

#### Usage

    RunStream$stream_async(
      on_message_delta = function(data) {
     },
      on_message = function(msg) {
     },
      on_run_step_delta = function(data) {
     },
      on_run_step = function(step) {
     },
      on_event = function(event) {
     },
      env = parent.frame()
    )

#### Arguments

- `on_message_delta`:

  A callback function to handle message delta events.

- `on_message`:

  A callback function to handle all message events.

- `on_run_step_delta`:

  A callback function to handle run step delta events.

- `on_run_step`:

  A callback function to handle all run step events.

- `on_event`:

  A callback function to handle all events.

- `env`:

  Environment to evaluate tool calls.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    RunStream$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
