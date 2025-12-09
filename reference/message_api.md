# A helper function for the `attachment` argument in `oai_create_message()` and `Message` objects.

- `oai_create_message()` Create a message in a thread.

Manage messages within threads

- `oai_list_messages()` List messages in a thread.

&nbsp;

- `oai_retrieve_message()` Retrieve a message.

&nbsp;

- `oai_modify_message()` Modify a message.

&nbsp;

- `oai_delete_message()` Delete a message.

## Usage

``` r
oai_create_message(
  thread_id,
  content,
  role = c("user", "assistant"),
  attachments = NULL,
  metadata = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_attachment(file_id, tools = c("code_interpreter", "file_search"))

oai_list_messages(
  thread_id,
  limit = NULL,
  order = NULL,
  after = NULL,
  before = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_retrieve_message(
  thread_id,
  message_id,
  .classify_response = TRUE,
  .async = FALSE
)

oai_modify_message(
  thread_id,
  message_id,
  metadata = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_delete_message(thread_id, message_id, .async = FALSE)
```

## Arguments

- thread_id:

  Character. The ID of the thread.

- content:

  Character. The content of the message.

- role:

  Character. The role of the sender.

- attachments:

  List or NULL. Optional. Attachments to include with the message.

- metadata:

  List or NULL. Optional. Metadata to include with the message.

- .classify_response:

  Logical. If `TRUE` (default), the response is classified as an R6
  object. If `FALSE`, the response is returned as a list.

- .async:

  Logical. If `TRUE`, the request is performed asynchronously.

- file_id:

  Character. The ID of the file.

- tools:

  Character. The tools to use with the attachment.

- limit:

  Integer. Optional. A limit on the number of objects to be returned.
  Limit can range between 1 and 100, and the default is 20.

- order:

  Character. Optional. Sort order by the created_at timestamp of the
  objects. `"asc"` for ascending order and `"desc"` for descending
  order.

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

- message_id:

  Character. The ID of the message.

## Value

A Message R6 object.

`oai_list_messages()` returns a list of messages in a thread.

`oai_delete_message()` returns the deletion status.
