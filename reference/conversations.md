# Conversations API

Based on the OpenAI API openapi specification.

Create a conversation

Retrieve a conversation

Update a conversation

Delete a conversation

List conversation items

Create conversation items

Retrieve an conversation item

Delete a conversation item

## Usage

``` r
oai_create_conversation(
  items = NULL,
  metadata = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_get_conversation(
  conversation_id,
  .classify_response = TRUE,
  .async = FALSE
)

oai_update_conversation(
  conversation_id,
  metadata = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_delete_conversation(conversation_id, .async = FALSE)

oai_list_conversation_items(
  conversation_id,
  limit = 20,
  order = c("desc", "asc"),
  after = NULL,
  include = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_create_conversation_items(
  conversation_id,
  items,
  include = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_retrieve_conversation_item(
  conversation_id,
  item_id,
  include = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_delete_conversation_item(
  conversation_id,
  item_id,
  .classify_response = TRUE,
  .async = FALSE
)
```

## Arguments

- items:

  List. The items to add to the conversation. You may add up to 20 items
  at a time.

- metadata:

  List. Optional. A named list of at most 16 key-value pairs that can be
  attached to an object. This can be useful for storing additional
  information about the object in a structured format, and querying for
  objects via API or the dashboard.

- .classify_response:

  Logical. If `TRUE` (default), the response is classified as an R6
  object. If `FALSE`, the response is returned as a list.

- .async:

  Logical. If `TRUE`, the request is performed asynchronously.

- conversation_id:

  Character. The ID of the conversation.

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

- include:

  Character vector. Specify additional output data to include in the
  model response.

- item_id:

  Character. The ID of the conversation item.

## Value

- `oai_create_conversation()` - A `Conversation` object.

&nbsp;

- `oai_get_conversation()` - A `Conversation` object.

&nbsp;

- `oai_update_conversation()` - The updated `Conversation` object.

&nbsp;

- `oai_delete_conversation()` - A success message.

&nbsp;

- `oai_list_conversation_items()` - A list object containing
  Conversation items.

&nbsp;

- `oai_create_conversation_items()` - The list of added items.

&nbsp;

- `oai_retrieve_conversation_item()` - A conversation item.

&nbsp;

- `oai_delete_conversation_item()` - An updated `Conversation` object.
