# R6 class for managing a Vector Store in the OpenAI API

R6 class for managing a Vector Store in the OpenAI API

R6 class for managing a Vector Store in the OpenAI API

## Details

The `VectorStore` class provides methods to manage vector stores.

## Super class

`openaiapi::Utils` -\> `VectorStore`

## Public fields

- `id`:

  Character. The unique identifier of the vector store.

- `created_at`:

  POSIXct. The timestamp when the vector store was created.

- `name`:

  Character. The name of the vector store.

- `usage_bytes`:

  Numeric. The total number of bytes used by the vector store.

- `file_counts`:

  Integer. The number of files in the vector store.

- `status`:

  Character. The current status of the vector store.

- `expires_after`:

  List. The duration after which the vector store will expire.

- `expires_at`:

  POSIXct. The exact timestamp when the vector store will expire.

- `last_active_at`:

  POSIXct. The last time the vector store was active.

- `metadata`:

  List. Additional metadata associated with the vector store.

## Methods

### Public methods

- [`VectorStore$new()`](#method-VectorStore-new)

- [`VectorStore$retrieve()`](#method-VectorStore-retrieve)

- [`VectorStore$modify()`](#method-VectorStore-modify)

- [`VectorStore$delete()`](#method-VectorStore-delete)

- [`VectorStore$create_file()`](#method-VectorStore-create_file)

- [`VectorStore$upload_file()`](#method-VectorStore-upload_file)

- [`VectorStore$list_files()`](#method-VectorStore-list_files)

- [`VectorStore$retrieve_file()`](#method-VectorStore-retrieve_file)

- [`VectorStore$delete_file()`](#method-VectorStore-delete_file)

- [`VectorStore$search()`](#method-VectorStore-search)

- [`VectorStore$create_file_batch()`](#method-VectorStore-create_file_batch)

- [`VectorStore$retrieve_file_batch()`](#method-VectorStore-retrieve_file_batch)

- [`VectorStore$cancel_file_batch()`](#method-VectorStore-cancel_file_batch)

- [`VectorStore$list_files_in_a_batch()`](#method-VectorStore-list_files_in_a_batch)

- [`VectorStore$print()`](#method-VectorStore-print)

- [`VectorStore$clone()`](#method-VectorStore-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize a VectorStore object

#### Usage

    VectorStore$new(vector_store_id = NULL, ..., resp = NULL)

#### Arguments

- `vector_store_id`:

  Character. Optional. The ID of the vector store to initialize.

- `...`:

  Additional arguments to be passed to the API functions.

- `resp`:

  A list. The response object from the OpenAI API containing details of
  the vector store.

#### Returns

A new instance of a VectorStore object.

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve the vector store

#### Usage

    VectorStore$retrieve()

#### Returns

The updated VectorStore object after retrieving its details from the
OpenAI API.

------------------------------------------------------------------------

### Method `modify()`

Modify the vector store. The `...` argument is passed to
[`oai_modify_vector_store()`](https://robonomist.github.io/openaiapi/reference/vector_store_api.md).

#### Usage

    VectorStore$modify(...)

#### Arguments

- `...`:

  Additional arguments to be passed to the API functions.

------------------------------------------------------------------------

### Method `delete()`

Delete the vector store.

#### Usage

    VectorStore$delete()

------------------------------------------------------------------------

### Method `create_file()`

Create a file in the vector store. The `...` argument is passed to
[`oai_create_vector_store_file()`](https://robonomist.github.io/openaiapi/reference/vector_store_file_api.md).

#### Usage

    VectorStore$create_file(file_id, ...)

#### Arguments

- `file_id`:

  Character. The ID of the file to be added to the vector store.

- `...`:

  Additional arguments to be passed to the API functions.

------------------------------------------------------------------------

### Method `upload_file()`

Upload a file to the vector store. The `...` argument is passed to
[`oai_upload_file()`](https://robonomist.github.io/openaiapi/reference/files_api.md).

#### Usage

    VectorStore$upload_file(path, ...)

#### Arguments

- `path`:

  Character. The path to the file to upload.

- `...`:

  Additional arguments to be passed to the API functions.

------------------------------------------------------------------------

### Method `list_files()`

List files in the vector store. The `...` argument is passed to
[`oai_list_vector_store_files()`](https://robonomist.github.io/openaiapi/reference/vector_store_file_api.md).

#### Usage

    VectorStore$list_files(...)

#### Arguments

- `...`:

  Additional arguments to be passed to the API functions.

------------------------------------------------------------------------

### Method `retrieve_file()`

Retrieve a file in the vector store.

#### Usage

    VectorStore$retrieve_file(file_id)

#### Arguments

- `file_id`:

  Character. The ID of the file to be added to the vector store.

------------------------------------------------------------------------

### Method `delete_file()`

Delete a file in the vector store.

#### Usage

    VectorStore$delete_file(file_id)

#### Arguments

- `file_id`:

  Character. The ID of the file to be added to the vector store.

------------------------------------------------------------------------

### Method [`search()`](https://rdrr.io/r/base/search.html)

Search the vector store.

#### Usage

    VectorStore$search(query, ...)

#### Arguments

- `query`:

  Character. The query string for the search.

- `...`:

  Additional arguments to be passed to the API functions.

- `filters`:

  List. Optional. A filter to apply based on file attributes.

------------------------------------------------------------------------

### Method `create_file_batch()`

Create a file batch. The `...` argument is passed to
[`oai_create_vector_store_file_batch()`](https://robonomist.github.io/openaiapi/reference/vector_store_file_batch_api.md).

#### Usage

    VectorStore$create_file_batch(file_ids, ...)

#### Arguments

- `file_ids`:

  Character. Optional. A vector of file IDs to include in the vector
  store.

- `...`:

  Additional arguments to be passed to the API functions.

#### Returns

A VectorStoreFilesBatch R6 object.

------------------------------------------------------------------------

### Method `retrieve_file_batch()`

Retrieve a file batch.

#### Usage

    VectorStore$retrieve_file_batch(batch_id)

#### Arguments

- `batch_id`:

  Character. The ID of the batch to retrieve.

------------------------------------------------------------------------

### Method `cancel_file_batch()`

Cancel a file batch

#### Usage

    VectorStore$cancel_file_batch(batch_id)

#### Arguments

- `batch_id`:

  Character. The ID of the batch to retrieve.

------------------------------------------------------------------------

### Method `list_files_in_a_batch()`

List files in a batch

#### Usage

    VectorStore$list_files_in_a_batch(batch_id = batch_id, ...)

#### Arguments

- `batch_id`:

  Character. The ID of the batch to retrieve.

- `...`:

  Additional arguments to be passed to the API functions.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print the VectorStore object

#### Usage

    VectorStore$print(...)

#### Arguments

- `...`:

  Unused.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    VectorStore$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
