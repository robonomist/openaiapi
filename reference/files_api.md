# Files API

Files are used to upload documents that can be used with features like
Assistants, Fine-tuning, and Batch API.

- `oai_upload_file()` Upload a file to OpenAI.

&nbsp;

- `oai_list_files()` List all files uploaded to OpenAI.

&nbsp;

- `oai_retrieve_file()` Retrieve a specific file from OpenAI.

&nbsp;

- `oai_retrieve_file_content()` Retrieve the content of a specific file
  from OpenAI.

## Usage

``` r
oai_upload_file(
  path,
  purpose = c("assistants", "batch", "fine-tune", "vision", "user_data", "evals"),
  expires_after = NULL,
  name = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_list_files(
  purpose = NULL,
  limit = NULL,
  order = NULL,
  after = NULL,
  .classify_response = TRUE
)

oai_retrieve_file(file_id, .classify_response = TRUE, .async = FALSE)

oai_delete_file(file_id, .async = FALSE)

oai_retrieve_file_content(file_id, path, .async = FALSE)
```

## Arguments

- path:

  Character. The path to the file to upload.

- purpose:

  Character.

  - `oai_upload_file()`: The purpose of the file,

  - `oai_list_files()`: Optional. The purpose of the files to list.

- expires_after:

  List. The expiration policy for the file.

- name:

  Character. Optional. The name of the file. If not provided, the file
  name will be used.

- .classify_response:

  Logical. Whether to classify the response as an R6 object.

- .async:

  Logical. If `TRUE`, the request is performed asynchronously.

- limit:

  Integer. Optional. The maximum number of files to list. Defaults to
  10,000.

- order:

  Character. Optional. The order to list files. Can be "asc" or "desc".

- after:

  Character. Optional. The ID of the file to start the list from.

- file_id:

  Character. The ID of the file to delete.

## Value

A File R6 object

Deletion status

The response from the API.
