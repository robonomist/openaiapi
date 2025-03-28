
# openaiapi

openaiapi is an R package that provides a comprehensive and faithful
interface to the OpenAI API. It closely mirrors the API’s structure
while offering R6 classes for convenient handling of API objects.

## Installation

You can install the development version of openaiapi from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("robonomist/openaiapi")
```

## Usage

To use the OpenAI API, you need to have an API key. You can get one by
signing up at [OpenAI](https://platform.openai.com/).

``` r
library(openaiapi)
oai_set_api_key("your-api-key")
```

Alternatively, you can set the `OPENAI_API_KEY` environment variable,
which is read at package load time.

### Chat completions

The chat completions API allows you to generate chat completions. You
can use the `oai_create_chat_completion` function to generate
completions:

``` r
r <- oai_create_chat_completion(
  "Hello, how are you?",
  model = "gpt-4o"
)
r # A ChatCompletion R6 object
r$content_text()

oai_create_chat_completion(
  messages = list(
    oai_message("Hello, how are you?", role = "user"),
    oai_message("I'm fine, thank you!", role = "assistant"),
    oai_message("Can you tell me a joke?", role = "user")
  ),
  model = "gpt-4o"
)$content_text()
```

### Assistants

The Assistants API allows you build AI assistants for your applications.
Please refer to the [OpenAI
documentation](https://platform.openai.com/docs/assistants/overview) for
more information.

You can create a new assistant with the `oai_create_assistant` function:

``` r
oai_create_assistant(model = "gpt-4o", name = "my-assistant")
```

This will return a R6 Assistant object that you can use to interact with
the assistant.

To retrieve the an existing assistant, you can use the
`oai_retrieve_assistant` function:

``` r
oai_retrieve_assistant(assistant_id = "your-assistant-id")
```

Alternatively you can use Assistant class constructor directly:

``` r
## Create a new assistant
Assistant$new(model = "gpt-4o", name = "my-assistant")

## Retrieve an existing assistant
Assistant$new(assistant_id = "your-assistant-id")
```

To modify the assistant, you can use the `oai_modify_assistant` function
ore the `modify` method of the Assistant object:

``` r
oai_modify_assistant(
  assistant_id = "your-assistant-id",
  instructions =  = "new-instructions"
)
## or
my_assistant <- Assistant$new(assistant_id = "your-assistant-id")
my_assistant$modify(instructions = "new-instructions")
```

To delete the assistant, you can use the `oai_delete_assistant` function
or the `delete` method of the Assistant object.

### Threads

A Thread represents a conversation between a user and an assistant. You
can create a new thread with the `oai_create_thread` function or via the
Thread R6 class constructor:

``` r
my_thread <- oai_create_thread(messages = list(
  oai_message("Juha has entered the chat!", role = "assistant"),
  oai_message("Hello!", role = "user")
))
```

To run the thread, you can use the `run` method of the Thread object:

``` r
run <- thread$run(assistant = "your-assistant-id")
## or
run <- thread$run(assistant = my_assistant)
```

You can also create a thread and run it in one go:

``` r
run <- my_assistant$thread_and_run(messages = list(
  oai_message("Juha has entered the chat!", role = "assistant"),
  oai_message("Hello!", role = "user")
))
```

### Runs

Runs represent an execution on an assistant on a specific thread. You
can retrieve a run with the `oai_create_run()` function or via the Run
R6 class constructor:

``` r
run <- oai_create_run(
  thread_id = "your-thread-id",
  assistant_id = "your-assistant-id"
)

run <- Run$new(thread = "your-thread-id", assistant = "your-assistant-id")
## or
run <- Run$new(thread = my_thread, assistant = my_assistant)
```

You can retrieve the status of the run from the API with the
`retrieve_status()` method:

``` r
run$retrieve_status()
```

You can wait for the run to complete with the `wait()` method:

``` r
run$wait()
## or directly wait for the messages
run$wait()$thread()$list_messages()
```

Let’s put it all together:

``` r
my_assistant <- Assistant$new(
  model = "gpt-4o",
  name = "my-assistant",
  instructions = "Answer back when the user says hello."
)

my_thread <- Thread$new()
my_thread$create_message("Hello my assistant!")

my_run <- Run$new(thread = my_thread, assistant = my_assistant)$wait()

messages <- my_thread$list_messages()

messages[[1]]$content_text()
#> [1] "Hello! How can I assist you today?"

my_thread$create_message("Goodbye my assistant!")$run(my_assistant)$wait()

my_thread$list_messages()[[1]]$content_text()
#> [1] "Goodbye! If you need any help in the future, just let me know. Have a great day!"

my_assistant$delete()
```

#### Function tools

If your assistant uses function tools, the `wait()` method will
automatically execute the required function tools by finding the R
functions of the same name (by searching the calling environment by
default). If you want to use a different environment, you can specify it
with the `env` argument.

You can specify the function tools when creating the assistant using the
`oai_function_tool()` and `oai_function_tool_parameters()` functions:

``` r
package_version <- function(package) {
  as.character(packageVersion(package))
}
my_tool <- oai_function_tool(
  name = "package_version",
  description = "Get the version of a R packages",
  oai_function_tool_parameter(
    name = "package",
    type = "string",
    description = "Name of the package",
    required = TRUE
  )
)

my_test_assistant <- Assistant$new(
  model = "gpt-4o",
  name = "Test assistant",
  instructions = "You will provide the version of R packages when the user asks. Use the `package_version` function tool.",
  tools = list(my_tool)
)

messages <- my_test_assistant$thread_and_run(
  messages = list(
    oai_message("What is the version of openaiapi?", role = "user")
  )
)$wait()$thread()$list_messages()

messages[[1]]$content_text()
#> "The version of the `openaiapi` package is 0.0.0.9100."

my_test_assistant$delete()
```

## Files

### File uploads

You can upload files to the OpenAI API with the `oai_upload_file()`
function and by creating a File object:

``` r
file <- oai_upload_file("path/to/file")
## or
file <- File$new("path/to/file")
```

### Vector store

The Vector Store API allows you to store and retrieve vectors. You can
create a new vector store with the `oai_create_vector_store()` function
or by creating a VectorStore object:

``` r
my_vector_store <- oai_create_vector_store(name = "my-vector-store")
## or
my_vector_store <- VectorStore$new(name = "my-vector-store")
```

## Todo:

- [ ] Implement streaming
- [ ] Implement Administration API’s
- [ ] Implement Images API
- [ ] Implement Moderations API
- [ ] Implement Realtime API
- [ ] Add tests
