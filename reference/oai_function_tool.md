# Define a function tool

Define a function tool

Create a function tool parameter for `oai_function_tool`

## Usage

``` r
oai_function_tool(
  name,
  description = NULL,
  ...,
  parameters = NULL,
  strict = TRUE
)

oai_function_tool_parameter(
  name,
  type,
  description,
  required = TRUE,
  enum = NULL,
  ...
)
```

## Arguments

- name:

  The name of the parameter.

- description:

  A description of the parameter.

- ...:

  Additional properties to be added to the parameter.

- parameters:

  Parameters can be given alternatively a list of
  `oai_function_tool_parameter` objects.

- strict:

  Whether to enable strict schema adherence when generating the function
  call. If set to true, the model will follow the exact schema defined
  in the parameters field.

- type:

  The type of the parameter. Possible values are "string", "number",
  "boolean", "array", "object", and "null".

- required:

  Whether the parameter is required or optional.

- enum:

  A list of possible values for the parameter.
