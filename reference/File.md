# OpenAI File Interface

OpenAI File Interface

OpenAI File Interface

## Details

This class provides methods to interact with files in the OpenAI API.

## Super class

`openaiapi::Utils` -\> `File`

## Public fields

- `id`:

  The ID of the file.

- `bytes`:

  The size of the file in bytes.

- `created_at`:

  The creation time of the file.

- `expires_at`:

  The expiration time of the file.

- `filename`:

  The name of the file.

- `purpose`:

  The purpose of the file. Retrieve the file's properties from the API

## Methods

### Public methods

- [`File$new()`](#method-File-new)

- [`File$retrieve()`](#method-File-retrieve)

- [`File$delete()`](#method-File-delete)

- [`File$print()`](#method-File-print)

- [`File$clone()`](#method-File-clone)

------------------------------------------------------------------------

### Method `new()`

Initializes the File object

#### Usage

    File$new(file_id = NULL, path = NULL, ..., resp = NULL, .async = FALSE)

#### Arguments

- `file_id`:

  The ID of the file to initialize.

- `path`:

  The path to the file to upload.

- `...`:

  Additional arguments passed to the API functions.

- `resp`:

  A list containing the file properties from the API response.

- `.async`:

  Logical. If TRUE, the function will return a promise.

#### Returns

An instance of the File class.

------------------------------------------------------------------------

### Method `retrieve()`

#### Usage

    File$retrieve()

#### Returns

The up-to-date File instance. Delete the file

------------------------------------------------------------------------

### Method `delete()`

#### Usage

    File$delete()

#### Returns

NULL Print the file's details

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

#### Usage

    File$print(...)

#### Arguments

- `...`:

  Additional arguments (unused).

#### Returns

The File instance.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    File$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
