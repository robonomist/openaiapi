# ChatCompletion R6 class

ChatCompletion R6 class

ChatCompletion R6 class

## Super class

`openaiapi::Utils` -\> `ChatCompletion`

## Public fields

- `id`:

  A unique identifier for the chat completion.

- `choices`:

  A list of chat completion choices. Can be more than one if n is
  greater than 1.

- `created`:

  The Unix timestamp (in seconds) of when the chat completion was
  created.

- `model`:

  The model used for the chat completion.

- `service_tier`:

  The service tier used for processing the request.

- `system_fingerprint`:

  This fingerprint represents the backend configuration that the model
  runs with.

- `usage`:

  Usage statistics for the completion request.

## Methods

### Public methods

- [`ChatCompletion$new()`](#method-ChatCompletion-new)

- [`ChatCompletion$get()`](#method-ChatCompletion-get)

- [`ChatCompletion$update()`](#method-ChatCompletion-update)

- [`ChatCompletion$delete()`](#method-ChatCompletion-delete)

- [`ChatCompletion$get_chat_messages()`](#method-ChatCompletion-get_chat_messages)

- [`ChatCompletion$content_text()`](#method-ChatCompletion-content_text)

- [`ChatCompletion$print()`](#method-ChatCompletion-print)

- [`ChatCompletion$clone()`](#method-ChatCompletion-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize a ChatCompletion object.

#### Usage

    ChatCompletion$new(
      completion_id = NULL,
      messages = NULL,
      ...,
      resp = NULL,
      .async = FALSE
    )

#### Arguments

- `completion_id`:

  A unique identifier for the chat completion.

- `messages`:

  A list of messages comprising the conversation so far.

- `...`:

  Additional parameters passed to API functions

- `resp`:

  A response object.

- `.async`:

  Logical. If TRUE, the API call will be asynchronous.

------------------------------------------------------------------------

### Method [`get()`](https://rdrr.io/r/base/get.html)

Get the chat completion object.

#### Usage

    ChatCompletion$get()

------------------------------------------------------------------------

### Method [`update()`](https://rdrr.io/r/stats/update.html)

Update the chat completion object.

#### Usage

    ChatCompletion$update(metadata)

#### Arguments

- `metadata`:

  List of key-value pairs.

------------------------------------------------------------------------

### Method `delete()`

Delete the chat completion object.

#### Usage

    ChatCompletion$delete()

------------------------------------------------------------------------

### Method `get_chat_messages()`

Get the messages in the chat completion.

#### Usage

    ChatCompletion$get_chat_messages(...)

#### Arguments

- `...`:

  Additional parameters passed to API functions

------------------------------------------------------------------------

### Method `content_text()`

Get the messages in the chat completion.

#### Usage

    ChatCompletion$content_text(choice = 1)

#### Arguments

- `choice`:

  Integer. The choice number to get the message from.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print the chat completion details.

#### Usage

    ChatCompletion$print(...)

#### Arguments

- `...`:

  Additional parameters passed to API functions

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    ChatCompletion$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
