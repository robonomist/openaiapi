% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/run.R, R/run_step.R
\name{run_api}
\alias{run_api}
\alias{oai_create_run}
\alias{oai_create_thread_and_run}
\alias{oai_list_runs}
\alias{oai_list_run_steps}
\alias{oai_retrieve_run}
\alias{oai_modify_run}
\alias{oai_cancel_run}
\alias{oai_submit_tool_outputs}
\alias{oai_tool_output}
\alias{oai_retrieve_run_step}
\title{Run API}
\usage{
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
}
\arguments{
\item{thread_id}{Character. ID of the thread to run.}

\item{assistant_id}{Character. ID of the assistant to use to execute this run.}

\item{model}{Character. The ID of the Model to be used to execute this run. If a value is provided here, it will override the model associated with the assistant. If not, the model associated with the assistant will be used.}

\item{instructions}{Character. Overrides the instructions of the assistant. This is useful for modifying the behavior on a per-run basis.}

\item{additional_instructions}{Character. Appends additional instructions at the end of the instructions for the run. This is useful for modifying the behavior on a per-run basis without overriding other instructions.}

\item{additional_messages}{Character. Adds additional messages to the thread before creating the run.}

\item{tools}{Character. Override the tools the assistant can use for this run. This is useful for modifying the behavior on a per-run basis.}

\item{metadata}{List. Optional. A named list of at most 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format, and querying for objects via API or the dashboard.}

\item{temperature}{Numeric. What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.}

\item{top_p}{Numeric. An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10\% probability mass are considered.}

\item{stream}{Logical. If TRUE, the function will return a RunStream object.}

\item{max_prompt_tokens}{Integer. The maximum number of prompt tokens that may be used over the course of the run. The run will make a best effort to use only the number of prompt tokens specified, across multiple turns of the run. If the run exceeds the number of prompt tokens specified, the run will end with status incomplete. See incomplete_details for more info.}

\item{max_completion_tokens}{Integer. The maximum number of completion tokens that may be used over the course of the run. The run will make a best effort to use only the number of completion tokens specified, across multiple turns of the run. If the run exceeds the number of completion tokens specified, the run will end with status incomplete. See incomplete_details for more info.}

\item{truncation_strategy}{Object. Controls for how a thread will be truncated prior to the run. Use this to control the intial context window of the run.}

\item{tool_choice}{Character. Controls which (if any) tool is called by the model. none means the model will not call any tools and instead generates a message. auto is the default value and means the model can pick between generating a message or calling one or more tools. required means the model must call one or more tools before responding to the user.}

\item{response_format}{Character. Specifies the format that the model must output. Compatible with GPT-4o, GPT-4 Turbo, and all GPT-3.5 Turbo models since gpt-3.5-turbo-1106.}

\item{.classify_response}{Logical. If \code{TRUE} (default), the response is classified as an R6 object. If \code{FALSE}, the response is returned as a list.}

\item{.async}{Logical. If \code{TRUE}, the request is performed asynchronously.}

\item{thread}{List. A named list of thread parameters: "messages" (List), "tool_resources" (List), "metadata" (List).}

\item{tool_resources}{List. A list of resources that are used by the assistant's tools. The resources are specific to the type of tool. For example, the code_interpreter tool requires a list of file IDs, while the file_search tool requires a list of vector store IDs.}

\item{limit}{Integer. Optional. A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.}

\item{order}{Character. Optional. Sort order by the created_at timestamp of the objects. \code{"asc"} for ascending order and \code{"desc"} for descending order.}

\item{after}{Character. Optional. A cursor for use in pagination. \code{after} is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include \code{after = "obj_foo"} in order to fetch the next page of the list.}

\item{before}{Character. Optional. A cursor for use in pagination. before is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include \code{before = "obj_foo"} in order to fetch the previous page of the list.}

\item{run_id}{Character. ID of the run.}

\item{tool_outputs}{List of tool outputs.}

\item{tool_call_id}{Character. The ID of the tool call in the required_action object within the run object the output is being submitted for.}

\item{output}{Character. The output of the tool call to be submitted to continue the run.}

\item{step_id}{Character. ID of the step.}
}
\value{
A Run R6 object.

\code{oai_list_runs()} returns a list of \code{Run} objects.

\code{oai_list_run_steps()} returns a list of \code{RunStep} objects.

\code{oai_modify_run()} returns a \code{Run} object.

\code{oai_cancel_run()} returns a \code{Run} object.

\code{oai_submit_tool_outputs()} returns a \code{Run} object.

\code{oai_retrieve_run_step()} returns a \code{RunStep} object.
}
\description{
Runs represents executions run on a thread.

\itemize{
\item \code{oa_create_run()}: Create a new run.
}

\itemize{
\item \code{oai_create_thread_and_run()}: Create a new thread and run.
}

\itemize{
\item \code{oai_list_runs()}: List runs.
}

\itemize{
\item \code{oai_list_run_steps()}: List run steps.
}

\itemize{
\item \code{oai_retrieve_run()}: Retrieve a run.
}

\itemize{
\item \code{oai_modify_run()}: Modify a run.
}

\itemize{
\item \code{oai_cancel_run()}: Cancel a run.
}

\itemize{
\item \code{oai_submit_tool_outputs()}: Submit tool outputs.
}

\itemize{
\item \code{oai_tool_output()}: A helper function to format a tool output.
}

\itemize{
\item \code{oai_retrieve_run_step()}: Retrieve a run step.
}
}
