# VectorStoreFilesBatch R6 class

VectorStoreFilesBatch R6 class

VectorStoreFilesBatch R6 class

## Super class

`openaiapi::Utils` -\> `VectorStoreFilesBatch`

## Public fields

- `id`:

  Character. The ID of the file batch.

- `attributes`:

  List. The attributes of the file batch.

- `created_at`:

  POSIXct. The date and time the file batch was created.

- `vector_store_id`:

  Character. The ID of the vector store where the file batch was
  created.

- `status`:

  Character. The status of the file batch.

- `file_counts`:

  List. The number of files in the batch.

## Methods

### Public methods

- [`VectorStoreFilesBatch$new()`](#method-VectorStoreFilesBatch-new)

- [`VectorStoreFilesBatch$retrieve()`](#method-VectorStoreFilesBatch-retrieve)

- [`VectorStoreFilesBatch$cancel()`](#method-VectorStoreFilesBatch-cancel)

- [`VectorStoreFilesBatch$delete()`](#method-VectorStoreFilesBatch-delete)

- [`VectorStoreFilesBatch$list_files()`](#method-VectorStoreFilesBatch-list_files)

- [`VectorStoreFilesBatch$print()`](#method-VectorStoreFilesBatch-print)

- [`VectorStoreFilesBatch$clone()`](#method-VectorStoreFilesBatch-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize a VectorStoreFilesBatch object. The `...` argument is passed
to the API functions.

#### Usage

    VectorStoreFilesBatch$new(
      vector_store_id = NULL,
      batch_id = NULL,
      file_ids = NULL,
      paths = NULL,
      ...,
      resp = NULL
    )

#### Arguments

- `vector_store_id`:

  Character. The ID of the vector store where the file batch will be
  created.

- `batch_id`:

  Character. The ID of the batch to retrieve.

- `file_ids`:

  Character. A vector of file IDs to include in the batch.

- `paths`:

  Character. A vector of file paths to include in the batch.

- `...`:

  Additional arguments passed to the API functions.

- `resp`:

  List. The response from the API.

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve the file batch.

#### Usage

    VectorStoreFilesBatch$retrieve()

------------------------------------------------------------------------

### Method `cancel()`

Cancel the file batch.

#### Usage

    VectorStoreFilesBatch$cancel()

------------------------------------------------------------------------

### Method `delete()`

Delete the file batch.

#### Usage

    VectorStoreFilesBatch$delete()

------------------------------------------------------------------------

### Method `list_files()`

List all files in the file batch. The `...` argument is passed to
[`oai_list_vector_store_files()`](https://robonomist.github.io/openaiapi/reference/vector_store_file_api.md).

#### Usage

    VectorStoreFilesBatch$list_files(...)

#### Arguments

- `...`:

  Additional arguments passed to the API functions.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print the file batch.

#### Usage

    VectorStoreFilesBatch$print(...)

#### Arguments

- `...`:

  Additional arguments passed to the API functions.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    VectorStoreFilesBatch$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
