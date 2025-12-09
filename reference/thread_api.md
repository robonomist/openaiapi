# Threads API

Manage threads that assistants can interact with.

- `oai_create_thread()`: Create a new thread that assistants can
  interact with.

&nbsp;

- `oai_modify_thread()`: Modify a thread.

&nbsp;

- `oai_retrieve_thread()`: Retrieve a thread.

&nbsp;

- `oai_delete_thread()`: Delete a thread.

## Usage

``` r
oai_create_thread(
  messages = NULL,
  tool_resources = NULL,
  metadata = NULL,
  .classify_response = TRUE
)

oai_modify_thread(
  thread_id,
  tool_resources = NULL,
  metadata = NULL,
  .classify_response = TRUE
)

oai_retrieve_thread(thread_id, .classify_response = TRUE, .async = FALSE)

oai_delete_thread(thread_id)
```

## Arguments

- messages:

  A list of oai_messages to start the thread with.

- tool_resources:

  A list of tool resources that are available to the assistant.

- metadata:

  List. Optional. Set of 16 key-value pairs that can be attached to an
  object. This can be useful for storing additional information about
  the object in a structured format. Keys can be a maximum of 64
  characters long and values can be a maximum of 512 characters long.

- .classify_response:

  Logical. If `TRUE` (default), the response is classified as an R6
  object. If `FALSE`, the response is returned as a list.

- thread_id:

  The ID of the thread.

- .async:

  Logical. If `TRUE`, the request is performed asynchronously.
