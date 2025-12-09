# Message R6 class

Message R6 class

Message R6 class

## Super class

`openaiapi::Utils` -\> `Message`

## Public fields

- `id`:

  Character. The ID of the message.

- `created_at`:

  POSIXct. The time the message was created.

- `thread_id`:

  Character. The ID of the thread this message belongs to.

- `status`:

  Character. The status of the message.

- `incomplete_details`:

  List. Details about the message if it is incomplete.

- `completed_at`:

  POSIXct. The time the message was completed.

- `incomplete_at`:

  POSIXct. The time the message was marked as incomplete.

- `role`:

  Character. The role of the sender.

- `content`:

  List. The content of the message.

- `assistant_id`:

  Character. If applicable, the ID of the assistant that authored this
  message.

- `run_id`:

  Character. The ID of the run associated with the creation of this
  message. Value is null when messages are created manually using the
  create message or create thread endpoints.

- `attachments`:

  List. Attachments to the message.

- `metadata`:

  List. Metadata associated with the message.

## Methods

### Public methods

- [`Message$new()`](#method-Message-new)

- [`Message$retrieve()`](#method-Message-retrieve)

- [`Message$modify()`](#method-Message-modify)

- [`Message$delete()`](#method-Message-delete)

- [`Message$content_text()`](#method-Message-content_text)

- [`Message$thread()`](#method-Message-thread)

- [`Message$assistant()`](#method-Message-assistant)

- [`Message$add_delta()`](#method-Message-add_delta)

- [`Message$clone()`](#method-Message-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize a Message object.

#### Usage

    Message$new(
      message_id = NULL,
      thread_id = NULL,
      ...,
      resp = NULL,
      .async = FALSE
    )

#### Arguments

- `message_id`:

  Character. The ID of the message.

- `thread_id`:

  Character. The ID of the thread.

- `...`:

  Additional parameters passed to the API call.

- `resp`:

  List. The response from the OpenAI API.

- `.async`:

  Logical. If TRUE, the API call will be asynchronous.

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve the message.

#### Usage

    Message$retrieve()

------------------------------------------------------------------------

### Method `modify()`

Modify the message metadata.

#### Usage

    Message$modify(...)

#### Arguments

- `...`:

  Additional parameters passed to the API call.

------------------------------------------------------------------------

### Method `delete()`

Delete the message.

#### Usage

    Message$delete()

------------------------------------------------------------------------

### Method `content_text()`

Get the text content of the message.

#### Usage

    Message$content_text()

------------------------------------------------------------------------

### Method `thread()`

Get the thread this message belongs to.

#### Usage

    Message$thread()

------------------------------------------------------------------------

### Method `assistant()`

Get the assistant if applicable.

#### Usage

    Message$assistant()

------------------------------------------------------------------------

### Method `add_delta()`

Add message delta

#### Usage

    Message$add_delta(delta)

#### Arguments

- `delta`:

  List. Data from the `thread.message.delta` event.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Message$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
