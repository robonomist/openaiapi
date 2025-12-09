# Run API

Runs represents executions run on a thread.

- `oa_create_run()`: Create a new run.

&nbsp;

- `oai_create_thread_and_run()`: Create a new thread and run.

&nbsp;

- `oai_list_runs()`: List runs.

&nbsp;

- `oai_list_run_steps()`: List run steps.

&nbsp;

- `oai_retrieve_run()`: Retrieve a run.

&nbsp;

- `oai_modify_run()`: Modify a run.

&nbsp;

- `oai_cancel_run()`: Cancel a run.

&nbsp;

- `oai_submit_tool_outputs()`: Submit tool outputs.

&nbsp;

- `oai_tool_output()`: A helper function to format a tool output.

&nbsp;

- `oai_retrieve_run_step()`: Retrieve a run step.

## Usage

``` r
oai_create_run(
  thread_id,
  assistant_id,
  model = NULL,
  instructions = NULL,
  additional_instructions = NULL,
  additional_messages = NULL,
  tools = NULL,
  metadata = NULL,
  temperature = NULL,
  top_p = NULL,
  stream = NULL,
  max_prompt_tokens = NULL,
  max_completion_tokens = NULL,
  truncation_strategy = NULL,
  tool_choice = NULL,
  response_format = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_create_thread_and_run(
  assistant_id,
  thread = NULL,
  model = NULL,
  instructions = NULL,
  tools = NULL,
  tool_resources = NULL,
  metadata = NULL,
  temperature = NULL,
  top_p = NULL,
  stream = NULL,
  max_prompt_tokens = NULL,
  max_completion_tokens = NULL,
  truncation_strategy = NULL,
  tool_choice = NULL,
  response_format = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_list_runs(
  thread_id,
  limit = NULL,
  order = NULL,
  after = NULL,
  before = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_list_run_steps(
  thread_id,
  run_id,
  limit = NULL,
  order = NULL,
  after = NULL,
  before = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_retrieve_run(thread_id, run_id, .classify_response = TRUE, .async = FALSE)

oai_modify_run(
  thread_id,
  run_id,
  metadata = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_cancel_run(thread_id, run_id, .classify_response = TRUE, .async = FALSE)

oai_submit_tool_outputs(
  thread_id,
  run_id,
  tool_outputs,
  stream = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_tool_output(tool_call_id, output)

oai_retrieve_run_step(
  thread_id,
  run_id,
  step_id,
  .classify_response = TRUE,
  .async = FALSE
)
```

## Arguments

- thread_id:

  Character. ID of the thread to run.

- assistant_id:

  Character. ID of the assistant to use to execute this run.

- model:

  Character. The ID of the Model to be used to execute this run. If a
  value is provided here, it will override the model associated with the
  assistant. If not, the model associated with the assistant will be
  used.

- instructions:

  Character. Overrides the instructions of the assistant. This is useful
  for modifying the behavior on a per-run basis.

- additional_instructions:

  Character. Appends additional instructions at the end of the
  instructions for the run. This is useful for modifying the behavior on
  a per-run basis without overriding other instructions.

- additional_messages:

  Character. Adds additional messages to the thread before creating the
  run.

- tools:

  Character. Override the tools the assistant can use for this run. This
  is useful for modifying the behavior on a per-run basis.

- metadata:

  List. Optional. A named list of at most 16 key-value pairs that can be
  attached to an object. This can be useful for storing additional
  information about the object in a structured format, and querying for
  objects via API or the dashboard.

- temperature:

  Numeric. What sampling temperature to use, between 0 and 2. Higher
  values like 0.8 will make the output more random, while lower values
  like 0.2 will make it more focused and deterministic.

- top_p:

  Numeric. An alternative to sampling with temperature, called nucleus
  sampling, where the model considers the results of the tokens with
  top_p probability mass. So 0.1 means only the tokens comprising the
  top 10% probability mass are considered.

- stream:

  Logical. If TRUE, the function will return a RunStream object.

- max_prompt_tokens:

  Integer. The maximum number of prompt tokens that may be used over the
  course of the run. The run will make a best effort to use only the
  number of prompt tokens specified, across multiple turns of the run.
  If the run exceeds the number of prompt tokens specified, the run will
  end with status incomplete. See incomplete_details for more info.

- max_completion_tokens:

  Integer. The maximum number of completion tokens that may be used over
  the course of the run. The run will make a best effort to use only the
  number of completion tokens specified, across multiple turns of the
  run. If the run exceeds the number of completion tokens specified, the
  run will end with status incomplete. See incomplete_details for more
  info.

- truncation_strategy:

  Object. Controls for how a thread will be truncated prior to the run.
  Use this to control the intial context window of the run.

- tool_choice:

  Character. Controls which (if any) tool is called by the model. none
  means the model will not call any tools and instead generates a
  message. auto is the default value and means the model can pick
  between generating a message or calling one or more tools. required
  means the model must call one or more tools before responding to the
  user.

- response_format:

  Character. Specifies the format that the model must output. Compatible
  with GPT-4o, GPT-4 Turbo, and all GPT-3.5 Turbo models since
  gpt-3.5-turbo-1106.

- .classify_response:

  Logical. If `TRUE` (default), the response is classified as an R6
  object. If `FALSE`, the response is returned as a list.

- .async:

  Logical. If `TRUE`, the request is performed asynchronously.

- thread:

  List. A named list of thread parameters: "messages" (List),
  "tool_resources" (List), "metadata" (List).

- tool_resources:

  List. A list of resources that are used by the assistant's tools. The
  resources are specific to the type of tool. For example, the
  code_interpreter tool requires a list of file IDs, while the
  file_search tool requires a list of vector store IDs.

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

- run_id:

  Character. ID of the run.

- tool_outputs:

  List of tool outputs.

- tool_call_id:

  Character. The ID of the tool call in the required_action object
  within the run object the output is being submitted for.

- output:

  Character. The output of the tool call to be submitted to continue the
  run.

- step_id:

  Character. ID of the step.

## Value

A Run R6 object.

`oai_list_runs()` returns a list of `Run` objects.

`oai_list_run_steps()` returns a list of `RunStep` objects.

`oai_modify_run()` returns a `Run` object.

`oai_cancel_run()` returns a `Run` object.

`oai_submit_tool_outputs()` returns a `Run` object.

`oai_retrieve_run_step()` returns a `RunStep` object.
