#' Fine-tuning API
#'
#' Manage fine-tuning jobs to tailor a model to your specific training data.
#'
#' @param model The name of the model to fine-tune. You can select one of the supported models.
#' @param training_file The ID of an uploaded file that contains training data.
#' @param hyperparameters The hyperparameters used for the fine-tuning job.
#' @param suffix A string of up to 64 characters that will be added to your fine-tuned model name.
#' @param validation_file The ID of an uploaded file that contains validation data.
#' @param integrations A list of integrations to enable for your fine-tuning job.
#' @param seed The seed controls the reproducibility of the job. Passing in the same seed and job parameters should produce the same results, but may differ in rare cases. If a seed is not specified, one will be generated for you.
#' @inheritParams oai_create_assistant
#' @return A FineTuningJob R6 object.
#' @name fine_tuning_api
#' @seealso `FineTuningJob`
NULL

#' @description * `oai_create_fine_tuning_job()` creates a fine-tuning job.
#' @export
#' @rdname fine_tuning_api
oai_create_fine_tuning_job <- function(model,
                                       training_file,
                                       hyperparameters = NULL,
                                       suffix = NULL,
                                       validation_file = NULL,
                                       integrations = NULL,
                                       seed = NULL,
                                       .classify_response = TRUE) {
  body <- list(
    model = model,
    training_file = training_file,
    hyperparameters = hyperparameters,
    suffix = suffix,
    validation_file = validation_file,
    integrations = integrations,
    seed = seed
  )
  oai_query(
    ep = c("fine_tuning", "jobs"),
    body = body,
    method = "POST",
    .classify_response = .classify_response
  )
}

#' @description * `oai_list_fine_tuning_jobs()` lists fine-tuning jobs.
#' @param after Identifier for the last job from the previous pagination request.
#' @param limit Number of fine-tuning jobs to retrieve.
#' @return `oai_list_fine_tuning_jobs()` returns a list of FineTuningJob R6 objects.
#' @export
#' @rdname fine_tuning_api
oai_list_fine_tuning_jobs <- function(after = NULL,
                                      limit = NULL,
                                      .classify_response = TRUE) {
  query <- list(
    after = after,
    limit = limit
  ) |> compact()
  oai_query(
    ep = "fine_tuning/jobs",
    query = query,,
    method = "GET",
    .classify_response = .classify_response
  )
}

#' @description * `oai_list_fine_tuning_events()` lists fine-tuning events.
#' @param fine_tuning_job_id The ID of the fine-tuning job to get events for.
#' @param after Identifier for the last event from the previous pagination request.
#' @param limit Number of events to retrieve.
#' @return `oai_list_fine_tuning_events()` returns a list of FineTuningEvent R6 objects.
#' @export
#' @rdname fine_tuning_api
oai_list_fine_tuning_events <- function(fine_tuning_job_id,
                                        after = NULL,
                                        limit = NULL,
                                        .classify_response = TRUE) {
  query <- list(
    after = after,
    limit = limit
  ) |> compact()
  oai_query(
    ep = c("fine_tuning", "jobs", fine_tuning_job_id, "events"),
    query = query,
    method = "GET",
    .classify_response = .classify_response
  )
}

#' @description * `oai_list_fine_tuning_checkpoints()` lists fine-tuning checkpoints.
#' @param fine_tuning_job_id The ID of the fine-tuning job.
#' @param after Identifier for the last checkpoint ID from the previous pagination request.
#' @param limit Number of checkpoints to retrieve.
#' @return `oai_list_fine_tuning_checkpoints()` returns a list of FineTuningCheckpoint R6 objects.
#' @export
#' @rdname fine_tuning_api
oai_list_fine_tuning_checkpoints <- function(fine_tuning_job_id,
                                             after = NULL,
                                             limit = NULL,
                                             .classify_response = TRUE) {
  query <- list(
    after = after,
    limit = limit
  ) |> compact()
  oai_query(
    ep = c("fine_tuning", "jobs", fine_tuning_job_id, "checkpoints"),
    query = query,
    method = "GET",
    .classify_response = .classify_response
  )
}

#' @description * `oai_get_fine_tuning_job()` retrieves a fine-tuning job.
#' @export
#' @rdname fine_tuning_api
oai_get_fine_tuning_job <- function(fine_tuning_job_id,
                                    .classify_response = TRUE) {
  oai_query(
    ep = c("fine_tuning", "jobs", fine_tuning_job_id),
    method = "GET",
    .classify_response = .classify_response
  )
}

#' @description * `oa_cancel_fine_tuning()` cancels a fine-tuning job.
#' @export
#' @rdname fine_tuning_api
oai_cancel_fine_tuning <- function(fine_tuning_job_id,
                                  .classify_response = TRUE) {
  oai_query(
    ep = c("fine_tuning", "jobs", fine_tuning_job_id, "cancel"),
    method = "POST",
    .classify_response = .classify_response
  )
}

#' FineTuningJob R6 class
#'
#' @param model The name of the model to fine-tune.
#' @param training_file The ID of an uploaded file that contains training data.
#' @param resp The response from the API.
#' @param ... Additional parameters passed to the API functions.
#' @field id The ID of the fine-tuning job.
#' @field created_at The time the fine-tuning job was created.
#' @field error The error message, if any.
#' @field fine_tuned_model The name of the fine-tuned model.
#' @field finished_at The time the fine-tuning job finished.
#' @field hyperparameters The hyperparameters used for the fine-tuning job.
#' @field model The name of the model to fine-tune.
#' @field object The object type.
#' @field organization_id The ID of the organization.
#' @field result_files The result files.
#' @field status The status of the fine-tuning job.
#' @field trained_tokens The number of tokens trained.
#' @field training_file The ID of the training file.
#' @field validation_file The ID of the validation file.
#' @field integrations The integrations enabled for the fine-tuning job.
#' @field seed The seed used for the fine-tuning job.
#' @field estimated_finish The estimated finish time.
#' @importFrom R6 R6Class
#' @export
FineTuningJob <- R6Class(
  "FineTuningJob",
  portable = FALSE,
  public = list(
    #' @description Initialize a FineTuningJob object.
    initialize = function(model = NULL,
                          training_file = NULL, ...,
                          resp = NULL) {
      if (!is.null(resp)) {
        id <<- resp$id
        created_at <<- resp$created_at |> as_time()
        error <<- resp$error
        fine_tuned_model <<- resp$fine_tuned_model
        finished_at <<- resp$finished_at |> as_time()
        hyperparameters <<- resp$hyperparameters
        model <<- resp$model
        object <<- resp$object
        organization_id <<- resp$organization_id
        result_files <<- resp$result_files
        status <<- resp$status
        trained_tokens <<- resp$trained_tokens
        training_file <<- resp$training_file
        validation_file <<- resp$validation_file
        integrations <<- resp$integrations
        seed <<- resp$seed
        estimated_finish <<- resp$estimated_finish |> as_time()
      } else if (!is.null(model) & is.null(training_file)) {
        oai_create_fine_tuning_job(
          model = model,
          training_file = training_file,
          ...,
          .classify_response = FALSE
        ) |> initialize(resp = _)
      }
    },
    #' @description List fine-tuning events.
    list_events = function(...) {
      oai_list_fine_tuning_events(fine_tuning_job_id = self$id, ...)
    },
    #' @description List fine-tuning checkpoints.
    list_checkpoints = function(...) {
      oai_list_fine_tuning_checkpoints(fine_tuning_job_id = self$id, ...)
    },
    #' @description Retrieve the fine-tuning job.
    retrieve = function() {
      oai_get_fine_tuning_job(fine_tuning_job_id = self$id)
    },
    #' @description Cancel the fine-tuning job.
    cancel = function() {
      oa_cancel_fine_tuning(fine_tuning_job_id = self$id)
    },
    id = NULL,
    created_at = NULL,
    error = NULL,
    fine_tuned_model = NULL,
    finished_at = NULL,
    hyperparameters = NULL,
    model = NULL,
    object = NULL,
    organization_id = NULL,
    result_files = NULL,
    status = NULL,
    trained_tokens = NULL,
    training_file = NULL,
    validation_file = NULL,
    integrations = NULL,
    seed = NULL,
    estimated_finish = NULL
  )
)

