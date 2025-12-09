# FineTuningJob R6 class

FineTuningJob R6 class

FineTuningJob R6 class

## Super class

`openaiapi::Utils` -\> `FineTuningJob`

## Public fields

- `id`:

  The ID of the fine-tuning job.

- `created_at`:

  The time the fine-tuning job was created.

- `error`:

  The error message, if any.

- `fine_tuned_model`:

  The name of the fine-tuned model.

- `finished_at`:

  The time the fine-tuning job finished.

- `hyperparameters`:

  The hyperparameters used for the fine-tuning job.

- `model`:

  The name of the model to fine-tune.

- `object`:

  The object type.

- `organization_id`:

  The ID of the organization.

- `result_files`:

  The result files.

- `status`:

  The status of the fine-tuning job.

- `trained_tokens`:

  The number of tokens trained.

- `training_file`:

  The ID of the training file.

- `validation_file`:

  The ID of the validation file.

- `integrations`:

  The integrations enabled for the fine-tuning job.

- `seed`:

  The seed used for the fine-tuning job.

- `estimated_finish`:

  The estimated finish time.

## Methods

### Public methods

- [`FineTuningJob$new()`](#method-FineTuningJob-new)

- [`FineTuningJob$list_events()`](#method-FineTuningJob-list_events)

- [`FineTuningJob$list_checkpoints()`](#method-FineTuningJob-list_checkpoints)

- [`FineTuningJob$retrieve()`](#method-FineTuningJob-retrieve)

- [`FineTuningJob$cancel()`](#method-FineTuningJob-cancel)

- [`FineTuningJob$clone()`](#method-FineTuningJob-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize a FineTuningJob object.

#### Usage

    FineTuningJob$new(
      model = NULL,
      training_file = NULL,
      ...,
      resp = NULL,
      .async = FALSE
    )

#### Arguments

- `model`:

  The name of the model to fine-tune.

- `training_file`:

  The ID of an uploaded file that contains training data.

- `...`:

  Additional parameters passed to the API functions.

- `resp`:

  The response from the API.

- `.async`:

  Logical. If TRUE, the function will return a promise.

------------------------------------------------------------------------

### Method `list_events()`

List fine-tuning events.

#### Usage

    FineTuningJob$list_events(...)

#### Arguments

- `...`:

  Additional parameters passed to the API functions.

------------------------------------------------------------------------

### Method `list_checkpoints()`

List fine-tuning checkpoints.

#### Usage

    FineTuningJob$list_checkpoints(...)

#### Arguments

- `...`:

  Additional parameters passed to the API functions.

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve the fine-tuning job.

#### Usage

    FineTuningJob$retrieve()

------------------------------------------------------------------------

### Method `cancel()`

Cancel the fine-tuning job.

#### Usage

    FineTuningJob$cancel()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    FineTuningJob$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
