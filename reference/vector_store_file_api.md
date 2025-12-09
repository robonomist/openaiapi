# Vector store files API

Vector store files represent files inside a vector store.

- `oai_create_vector_store_file()`: Create a new file in a vector store.

&nbsp;

- `oai_list_vector_store_files()`: List files in a vector store.

&nbsp;

- `oai_retrieve_vector_store_file()`: Retrieve a specific file from a
  vector store.

&nbsp;

- `oai_update_vector_store_file()`: Update attributes of a vector store
  file.

&nbsp;

- `oai_delete_vector_store_file()`: Delete a file from a vector store.

## Usage

``` r
oai_create_vector_store_file(
  vector_store_id,
  file_id,
  attributes = NULL,
  chunking_strategy = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_list_vector_store_files(
  vector_store_id,
  limit = NULL,
  order = NULL,
  after = NULL,
  before = NULL,
  filter = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_retrieve_vector_store_file(
  vector_store_id,
  file_id,
  .classify_response = TRUE,
  .async = FALSE
)

oai_update_vector_store_file(
  vector_store_id,
  file_id,
  attributes,
  .classify_response = TRUE,
  .async = FALSE
)

oai_delete_vector_store_file(vector_store_id, file_id, .async = FALSE)
```

## Arguments

- vector_store_id:

  Character. The ID of the vector store.

- file_id:

  Character. The ID of the file to be added to the vector store.

- attributes:

  Named list. A list of attributes to update, with a maximum of 16
  key-value pairs. Keys are strings with a maximum length of 64
  characters. Values are strings with a maximum length of 512
  characters, booleans, or numbers.

- chunking_strategy:

  List. Optional. Strategy for chunking data.

- .classify_response:

  Logical. If `TRUE` (default), the response is classified as an R6
  object. If `FALSE`, the response is returned as a list.

- .async:

  Logical. If `TRUE`, the request is performed asynchronously.

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

- filter:

  Character. Optional. Filter by file status. One of "in_progress",
  "completed", "failed", "cancelled".

## Value

VectorStoreFile R6 object.

A List of VectorStoreFile R6 objects.

Deletion status.
