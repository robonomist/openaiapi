# Thread R6 class

Thread R6 class

Thread R6 class

## Public fields

- `id`:

  The ID of the thread.

- `created_at`:

  The time the thread was created.

- `metadata`:

  Additional metadata about the thread.

## Methods

### Public methods

- [`Thread$new()`](#method-Thread-new)

- [`Thread$modify()`](#method-Thread-modify)

- [`Thread$retrieve()`](#method-Thread-retrieve)

- [`Thread$delete()`](#method-Thread-delete)

- [`Thread$create_message()`](#method-Thread-create_message)

- [`Thread$list_messages()`](#method-Thread-list_messages)

- [`Thread$run()`](#method-Thread-run)

- [`Thread$list_runs()`](#method-Thread-list_runs)

- [`Thread$clone()`](#method-Thread-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize the thread. If `thread_id` is provided, the thread is
retrieved from the API. The `...` argument is passed to
[`oai_create_thread()`](https://robonomist.github.io/openaiapi/reference/thread_api.md).

#### Usage

    Thread$new(thread_id = NULL, ..., resp = NULL)

#### Arguments

- `thread_id`:

  The ID of the thread.

- `...`:

  Additional arguments passed to the API functions.

- `resp`:

  A response from the OpenAI API.

------------------------------------------------------------------------

### Method `modify()`

Modify the thread. The `...` argument is passed to
[`oai_modify_thread()`](https://robonomist.github.io/openaiapi/reference/thread_api.md).

#### Usage

    Thread$modify(...)

#### Arguments

- `...`:

  Additional arguments passed to the API functions.

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve the thread. The `...` argument is passed to
[`oai_retrieve_thread()`](https://robonomist.github.io/openaiapi/reference/thread_api.md).

#### Usage

    Thread$retrieve(...)

#### Arguments

- `...`:

  Additional arguments passed to the API functions.

------------------------------------------------------------------------

### Method `delete()`

Delete the thread.

#### Usage

    Thread$delete()

------------------------------------------------------------------------

### Method `create_message()`

Create a new message in the thread. The `...` argument is passed to
[`oai_create_message()`](https://robonomist.github.io/openaiapi/reference/message_api.md).

#### Usage

    Thread$create_message(content, role = "user", ...)

#### Arguments

- `content`:

  The content of the message.

- `role`:

  The role of the message. Can be "user" or "assistant".

- `...`:

  Additional arguments passed to the API functions.

#### Returns

`create_message()` returns the thread object.

------------------------------------------------------------------------

### Method `list_messages()`

List messages in the thread. The `...` argument is passed to
[`oai_list_messages()`](https://robonomist.github.io/openaiapi/reference/message_api.md).

#### Usage

    Thread$list_messages(...)

#### Arguments

- `...`:

  Additional arguments passed to the API functions.

------------------------------------------------------------------------

### Method `run()`

Run the thread on an assistant. The `...` argument is passed to
[`oai_create_run()`](https://robonomist.github.io/openaiapi/reference/run_api.md).

#### Usage

    Thread$run(assistant_id, ...)

#### Arguments

- `assistant_id`:

  The assistant to run the thread on. Can be an Assistant object or an
  assistant ID.

- `...`:

  Additional arguments passed to the API functions.

------------------------------------------------------------------------

### Method `list_runs()`

List runs of the thread. The `...` argument is passed to
[`oai_list_runs()`](https://robonomist.github.io/openaiapi/reference/run_api.md).

#### Usage

    Thread$list_runs(...)

#### Arguments

- `...`:

  Additional arguments passed to the API functions.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Thread$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
