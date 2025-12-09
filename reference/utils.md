# A helper function for message arguments

A helper function for message arguments

A helper function for thread arguments

A helper function for tool resource arguments

## Usage

``` r
oai_message(content, role = "user", attachments = NULL, metadata = NULL, ...)

oai_thread(messages, tool_resources = NULL, metadata = NULL)

oai_tool_resource(code_interpreter_file_ids = NULL, vector_store_ids = NULL)
```

## Arguments

- content:

  Character. The content of the message.

- role:

  Character. The role of the sender (default is "user").

- attachments:

  List or NULL. Optional. Attachments to include with the message.

- metadata:

  List or NULL. Optional. Metadata to include with the thread.

- ...:

  Additional values to pass to the API.

- messages:

  A list of oai_message objects or a character vector.

- tool_resources:

  List. Optional. A list of tool resources to include with the thread.

- code_interpreter_file_ids, :

  Character A vector of file IDs fore the code interpreter to use.

- vector_store_ids, :

  Character A vector of vector store IDs for the file search to use.

## Value

A structured list representing the message.
