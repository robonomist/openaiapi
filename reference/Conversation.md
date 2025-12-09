# Conversation R6 Class

An R6 class representing a Conversation in the OpenAI API.

## Super class

`openaiapi::Utils` -\> `Conversation`

## Public fields

- `id`:

  The conversation ID.

- `object`:

  The object type, which is "conversation".

- `created_at`:

  The creation time of the conversation, in epoch seconds.

- `metadata`:

  Metadata associated with the conversation.

## Methods

### Public methods

- [`Conversation$new()`](#method-Conversation-new)

- [`Conversation$retrieve()`](#method-Conversation-retrieve)

- [`Conversation$update()`](#method-Conversation-update)

- [`Conversation$delete()`](#method-Conversation-delete)

- [`Conversation$list_items()`](#method-Conversation-list_items)

- [`Conversation$create_items()`](#method-Conversation-create_items)

- [`Conversation$retrieve_item()`](#method-Conversation-retrieve_item)

- [`Conversation$delete_item()`](#method-Conversation-delete_item)

- [`Conversation$clone()`](#method-Conversation-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize a Conversation object

#### Usage

    Conversation$new(conversation_id = NULL, ..., resp = NULL)

#### Arguments

- `conversation_id`:

  Character. The ID of the conversation.

- `...`:

  Additional arguments to be passed to the API functions.

- `resp`:

  A list. The object returned by the OpenAI API.

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve a fresh copy of the conversation from the API

#### Usage

    Conversation$retrieve()

------------------------------------------------------------------------

### Method [`update()`](https://rdrr.io/r/stats/update.html)

Update the conversation's metadata

#### Usage

    Conversation$update(...)

#### Arguments

- `...`:

  Additional arguments to be passed to the API functions.

------------------------------------------------------------------------

### Method `delete()`

Delete the conversation

#### Usage

    Conversation$delete()

------------------------------------------------------------------------

### Method `list_items()`

List items in the conversation

#### Usage

    Conversation$list_items(...)

#### Arguments

- `...`:

  Additional arguments to be passed to the API functions.

------------------------------------------------------------------------

### Method `create_items()`

Add items to the conversation

#### Usage

    Conversation$create_items(...)

#### Arguments

- `...`:

  Additional arguments to be passed to the API functions.

------------------------------------------------------------------------

### Method `retrieve_item()`

Retrieve a specific item from the conversation

#### Usage

    Conversation$retrieve_item(item_id, ...)

#### Arguments

- `item_id`:

  Character. The ID of a specific conversation item.

- `...`:

  Additional arguments to be passed to the API functions.

------------------------------------------------------------------------

### Method `delete_item()`

Delete a specific item from the conversation

#### Usage

    Conversation$delete_item(item_id)

#### Arguments

- `item_id`:

  Character. The ID of a specific conversation item.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Conversation$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
