# Assistant R6 class

This class provides methods to interact with the OpenAI Assistant API.

## Super class

`openaiapi::Utils` -\> `Assistant`

## Public fields

- `id`:

  The ID of the assistant.

- `created_at`:

  The creation time of the assistant.

- `name`:

  The name of the assistant.

- `description`:

  The description of the assistant.

- `model`:

  ID of the model to use. You can use the
  [`oai_list_models()`](https://robonomist.github.io/openaiapi/reference/models_api.md)
  function to see all of your available models.

- `instructions`:

  The system instructions that the assistant uses.

- `tools`:

  A list of tool enabled on the assistant.

- `tool_resources`:

  A set of resources that are used by the assistant's tools.

- `metadata`:

  Set of 16 key-value pairs that can be attached to an object.

- `temperature`:

  Sampling temperature.

- `top_p`:

  An alternative to sampling with temperature, called nucleus sampling.

- `response_format`:

  The response format of the assistant.

## Methods

### Public methods

- [`Assistant$new()`](#method-Assistant-new)

- [`Assistant$modify()`](#method-Assistant-modify)

- [`Assistant$retrieve()`](#method-Assistant-retrieve)

- [`Assistant$delete()`](#method-Assistant-delete)

- [`Assistant$print()`](#method-Assistant-print)

- [`Assistant$thread_and_run()`](#method-Assistant-thread_and_run)

- [`Assistant$clone()`](#method-Assistant-clone)

------------------------------------------------------------------------

### Method `new()`

Initializes the OpenAI Assistant object. You must provide either an
assistant ID or a model. If you provide an assistant ID, the assistant
is retrieved from the API. If you provide a model, a new assistant is
created, and `...` argument is used to pass additional arguments to the
[`oai_create_assistant()`](https://robonomist.github.io/openaiapi/reference/assistant_api.md)
function.

#### Usage

    Assistant$new(
      assistant_id = NULL,
      model = NULL,
      ...,
      resp = NULL,
      .async = FALSE
    )

#### Arguments

- `assistant_id`:

  Character. The ID of the assistant to retrieve.

- `model`:

  Character. ID of the model to use. You can use the
  [`oai_list_models()`](https://robonomist.github.io/openaiapi/reference/models_api.md)
  to see all of your available models.

- `...`:

  Additional arguments passed to the `oai_*_assistant()` functions.

- `resp`:

  List. The assistant's properties from the API response.

- `.async`:

  Logical. If `TRUE`, requests are made asynchronously.

#### Returns

An instance of the OpenAI_Assistant class.

------------------------------------------------------------------------

### Method `modify()`

Modify the assistant's properties. The `...` argument is used to pass
additional arguments to the
[`oai_modify_assistant()`](https://robonomist.github.io/openaiapi/reference/assistant_api.md)
function.

#### Usage

    Assistant$modify(...)

#### Arguments

- `...`:

  Additional arguments passed to the `oai_*_assistant()` functions.

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve the assistant's properties from the API.

#### Usage

    Assistant$retrieve()

#### Returns

The up-to-date version of OpenAI_Assistant instance. Delete the
assistant

------------------------------------------------------------------------

### Method `delete()`

#### Usage

    Assistant$delete()

#### Returns

Deletion status Print the assistant's details

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

#### Usage

    Assistant$print(...)

#### Arguments

- `...`:

  Additional arguments (unused).

#### Returns

The OpenAI_Assistant instance. Create a thread and run the assistant

------------------------------------------------------------------------

### Method `thread_and_run()`

#### Usage

    Assistant$thread_and_run(thread = NULL, messages = NULL, ..., .async = NULL)

#### Arguments

- `thread`:

  An oai_thread object.

- `messages`:

  Alternatively, a list of messages to create a thread.

- `...`:

  Additional arguments passed to
  [`oai_create_thread_and_run()`](https://robonomist.github.io/openaiapi/reference/run_api.md).

- `.async`:

  Logical. If `TRUE`, requests are made asynchronously.

#### Returns

The response from the thread creation and run.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Assistant$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
