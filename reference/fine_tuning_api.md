# Fine-tuning API

Manage fine-tuning jobs to tailor a model to your specific training
data.

- `oai_create_fine_tuning_job()` creates a fine-tuning job.

&nbsp;

- `oai_list_fine_tuning_jobs()` lists fine-tuning jobs.

&nbsp;

- `oai_list_fine_tuning_events()` lists fine-tuning events.

&nbsp;

- `oai_list_fine_tuning_checkpoints()` lists fine-tuning checkpoints.

&nbsp;

- `oai_get_fine_tuning_job()` retrieves a fine-tuning job.

&nbsp;

- `oa_cancel_fine_tuning()` cancels a fine-tuning job.

## Usage

``` r
oai_create_fine_tuning_job(
  model,
  training_file,
  hyperparameters = NULL,
  suffix = NULL,
  validation_file = NULL,
  integrations = NULL,
  seed = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_list_fine_tuning_jobs(
  after = NULL,
  limit = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_list_fine_tuning_events(
  fine_tuning_job_id,
  after = NULL,
  limit = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_list_fine_tuning_checkpoints(
  fine_tuning_job_id,
  after = NULL,
  limit = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_get_fine_tuning_job(
  fine_tuning_job_id,
  .classify_response = TRUE,
  .async = FALSE
)

oai_cancel_fine_tuning(
  fine_tuning_job_id,
  .classify_response = TRUE,
  .async = FALSE
)
```

## Arguments

- model:

  The name of the model to fine-tune. You can select one of the
  supported models.

- training_file:

  The ID of an uploaded file that contains training data.

- hyperparameters:

  The hyperparameters used for the fine-tuning job.

- suffix:

  A string of up to 64 characters that will be added to your fine-tuned
  model name.

- validation_file:

  The ID of an uploaded file that contains validation data.

- integrations:

  A list of integrations to enable for your fine-tuning job.

- seed:

  The seed controls the reproducibility of the job. Passing in the same
  seed and job parameters should produce the same results, but may
  differ in rare cases. If a seed is not specified, one will be
  generated for you.

- .classify_response:

  Logical. If `TRUE` (default), the response is classified as an R6
  object. If `FALSE`, the response is returned as a list.

- .async:

  Logical. If `TRUE`, the request is performed asynchronously.

- after:

  Identifier for the last checkpoint ID from the previous pagination
  request.

- limit:

  Number of checkpoints to retrieve.

- fine_tuning_job_id:

  The ID of the fine-tuning job.

## Value

A FineTuningJob R6 object.

`oai_list_fine_tuning_jobs()` returns a list of FineTuningJob R6
objects.

`oai_list_fine_tuning_events()` returns a list of FineTuningEvent R6
objects.

`oai_list_fine_tuning_checkpoints()` returns a list of
FineTuningCheckpoint R6 objects.

## See also

`FineTuningJob`
