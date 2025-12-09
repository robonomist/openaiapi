# Vector store file batch API

Vector store file batches represent operations to add multiple files to
a vector store.

- `oai_create_vector_store_file_batch()`: Create a file batch in a
  vector store.

&nbsp;

- `oai_retrieve_vector_store_file_batch()`: Retrieve a specific file
  batch in a vector store.

&nbsp;

- `oai_delete_vector_store_file_batch()`: Delete a specific file batch
  in a vector store.

&nbsp;

- `oai_list_vector_store_files_in_a_batch()`: List all files in a file
  batch.

## Usage

``` r
oai_create_vector_store_file_batch(
  vector_store_id,
  file_ids,
  attributes = NULL,
  chunking_strategy = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_retrieve_vector_store_file_batch(
  vector_store_id,
  batch_id,
  .classify_response = TRUE,
  .async = FALSE
)

oai_cancel_vector_store_file_batch(vector_store_id, batch_id, .async = FALSE)

oai_list_vector_store_files_in_a_batch(
  vector_store_id,
  batch_id,
  limit = NULL,
  order = NULL,
  after = NULL,
  before = NULL,
  filter = NULL,
  .classify_response = TRUE,
  .async = FALSE
)
```

## Arguments

- vector_store_id:

  Character. The ID of the vector store where the file batch will be
  created.

- file_ids:

  Character. A vector of file IDs to include in the batch.

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

- batch_id:

  Character. The ID of the batch to retrieve.

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

  Character. Optional. Filter the files based on certain criteria.

## Value

A VectorStoreFilesBatch R6 object.

`oai_list_vector_store_files_in_a_batch()` returns a list of
VectorStoreFile objects.
