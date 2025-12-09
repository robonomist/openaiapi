# VectorStoreFile R6 class

VectorStoreFile R6 class

VectorStoreFile R6 class

## Super class

`openaiapi::Utils` -\> `VectorStoreFile`

## Public fields

- `id`:

  Character. The ID of the vector store file.

- `attributes`:

  Named list. A list of attributes associated with the vector store
  file.

- `created_at`:

  POSIXct. The time the vector store file was created.

- `status`:

  Character. The status of the vector store file. One of "in_progress",
  "completed", "failed", "cancelled".

- `chunking_strategy`:

  List. The strategy used to chunk the data.

- `usage_bytes`:

  Integer. The number of bytes used by the vector store file.

- `vector_store_id`:

  Character. The ID of the vector store that the file belongs to.

- `last_error`:

  Character. The last error that occurred while processing the file.

## Methods

### Public methods

- [`VectorStoreFile$new()`](#method-VectorStoreFile-new)

- [`VectorStoreFile$retrieve()`](#method-VectorStoreFile-retrieve)

- [`VectorStoreFile$update()`](#method-VectorStoreFile-update)

- [`VectorStoreFile$delete()`](#method-VectorStoreFile-delete)

- [`VectorStoreFile$print()`](#method-VectorStoreFile-print)

- [`VectorStoreFile$clone()`](#method-VectorStoreFile-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize a new VectorStoreFile object. Either provide a
vector_store_file_id or a vector_store_id together with a file_id or a
path to a file.

#### Usage

    VectorStoreFile$new(
      vector_store_file_id = NULL,
      vector_store_id = NULL,
      file_id = NULL,
      path = NULL,
      resp = NULL
    )

#### Arguments

- `vector_store_file_id`:

  Character. The ID of the vector store file.

- `vector_store_id`:

  Character. The ID of the vector store that the file belongs to.

- `file_id`:

  Character. The ID of the file that the vector store file is associated
  with.

- `path`:

  Character. The path to the file that the vector store file is
  associated with.

- `resp`:

  List. The response object from the OpenAI API.

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve the vector store file from the OpenAI API.

#### Usage

    VectorStoreFile$retrieve()

------------------------------------------------------------------------

### Method [`update()`](https://rdrr.io/r/stats/update.html)

Update the vector store file in the OpenAI API.

#### Usage

    VectorStoreFile$update(attributes)

#### Arguments

- `attributes`:

  Named list. A list of attributes to update, with a maximum of 16
  key-value pairs. Keys are strings with a maximum length of 64
  characters. Values are strings with a maximum length of 512
  characters, booleans, or numbers.

------------------------------------------------------------------------

### Method `delete()`

Delete the vector store file from the OpenAI API.

#### Usage

    VectorStoreFile$delete()

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print the vector store file.

#### Usage

    VectorStoreFile$print(...)

#### Arguments

- `...`:

  Additional arguments passed to API functions.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    VectorStoreFile$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
