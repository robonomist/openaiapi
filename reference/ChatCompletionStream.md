# ChatCompletionStream R6 class

ChatCompletionStream R6 class

ChatCompletionStream R6 class

## Super classes

`openaiapi::Utils` -\>
[`openaiapi::ChatCompletion`](https://robonomist.github.io/openaiapi/reference/ChatCompletion.md)
-\> `ChatCompletionStream`

## Methods

### Public methods

- [`ChatCompletionStream$new()`](#method-ChatCompletionStream-new)

- [`ChatCompletionStream$stream_async()`](#method-ChatCompletionStream-stream_async)

- [`ChatCompletionStream$do_tool_calls()`](#method-ChatCompletionStream-do_tool_calls)

- [`ChatCompletionStream$clone()`](#method-ChatCompletionStream-clone)

Inherited methods

- [`openaiapi::ChatCompletion$content_text()`](https://robonomist.github.io/openaiapi/reference/ChatCompletion.html#method-content_text)
- [`openaiapi::ChatCompletion$delete()`](https://robonomist.github.io/openaiapi/reference/ChatCompletion.html#method-delete)
- [`openaiapi::ChatCompletion$get()`](https://robonomist.github.io/openaiapi/reference/ChatCompletion.html#method-get)
- [`openaiapi::ChatCompletion$get_chat_messages()`](https://robonomist.github.io/openaiapi/reference/ChatCompletion.html#method-get_chat_messages)
- [`openaiapi::ChatCompletion$print()`](https://robonomist.github.io/openaiapi/reference/ChatCompletion.html#method-print)
- [`openaiapi::ChatCompletion$update()`](https://robonomist.github.io/openaiapi/reference/ChatCompletion.html#method-update)

------------------------------------------------------------------------

### Method `new()`

Initialize a ChatCompletionStream object.

#### Usage

    ChatCompletionStream$new(stream_reader)

#### Arguments

- `stream_reader`:

  A StreamReader object.

------------------------------------------------------------------------

### Method `stream_async()`

Get the chat completion object.

#### Usage

    ChatCompletionStream$stream_async(callback)

#### Arguments

- `callback`:

  A function that is called on each event, taking the updated `choices`
  field as an argument.

------------------------------------------------------------------------

### Method `do_tool_calls()`

Get the chat completion object.

#### Usage

    ChatCompletionStream$do_tool_calls(env = parent.env())

#### Arguments

- `env`:

  The environment to use for tool calls.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    ChatCompletionStream$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
