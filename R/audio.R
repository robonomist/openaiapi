#' Audio API
#'
#' Turn audio into text or text into audio.
#' @inheritParams common_parameters
#' @name audio
NULL

#' @description * `oai_create_speec()`: Generates audio from the input text.
#' @param input Character. The text to generate audio for. The maximum length is 4096 characters.
#' @param path Character. The path to save the audio file.
#' @param model Character. One of the available TTS models: tts-1 or tts-1-hd.
#' @param voice Character. The voice to use when generating the audio. Supported voices are alloy, ash, coral, echo, fable, onyx, nova, sage and shimmer. Previews of the voices are available in the Text to speech guide.
#' @param response_format Character. The format to audio in. Supported formats are mp3, opus, aac, flac, wav, and pcm.
#' @param speed Numeric. The speed of the generated audio. Select a value from 0.25 to 4.0. 1.0 is the default.
#' @return Returns the audio file content.
#' @export
#' @rdname audio
oai_create_speech <- function(input,
                              path,
                              model = c("tts-1", "tts-1-hd"),
                              voice = c("alloy", "ash", "coral", "echo", "fable", "onyx", "nova", "sage", "shimmer"),
                              response_format = c("mp3", "opus", "aac", "flac", "wav", "pcm"),
                              speed = NULL) {
  model <- match.arg(model)
  voice <- match.arg(voice)
  if (missing(response_format)) {
    # Try to get the extension from the path
    ext <- tools::file_ext(path)
    if (ext %in% c("mp3", "opus", "aac", "flac", "wav", "pcm")) {
      response_format <- ext
    } else {
      warning("`response_format` not provided and could not be inferred from the path. Defaulting to mp3.")
    }
  }
  response_format <- match.arg(response_format)
  body <- as.list(environment())
  oai_query(
    ep = c("audio", "speech"),
    method = "POST",
    body = body,
    path = path,
    .classify_response = NULL
  )
  path
}

#' @description * `oai_create_transcription()`: Transcribes audio into the input language.
#' @param file Character. The audio file object (not file name) to transcribe, in one of these formats: flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, or webm.
#' @param model Character. ID of the model to use. Only whisper-1 (which is powered by our open source Whisper V2 model) is currently available.
#' @param language Character. The language of the input audio. Supplying the input language in ISO-639-1 format will improve accuracy and latency.
#' @param prompt Character. An optional text to guide the model's style or continue a previous audio segment. The prompt should match the audio language.
#' @param response_format Character. The format of the output, in one of these options: json, text, srt, verbose_json, or vtt.
#' @param temperature Numeric. The sampling temperature, between 0 and 1. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. If set to 0, the model will use log probability to automatically increase the temperature until certain thresholds are hit.
#' @param timestamp_granularities List. The timestamp granularities to populate for this transcription. response_format must be set verbose_json to use timestamp granularities. Either or both of these options are supported: word, or segment. Note: There is no additional latency for segment timestamps, but generating word timestamps incurs additional latency.
#' @param name Character. The file name to use for the upload.
#' @return Returns the transcription object or a verbose transcription object.
#' @export
#' @rdname audio
oai_create_transcription <- function(file,
                                     model = "whisper-1",
                                     language = NULL,
                                     prompt = NULL,
                                     response_format = c("json", "text", "srt", "verbose_json", "vtt"),
                                     temperature = NULL,
                                     timestamp_granularities = NULL,
                                     name = NULL,
                                     .classify_response = TRUE) {
  response_format <- match.arg(response_format)
  body <- list(
    file = form_file(file, name = name),
    model = model,
    language = language,
    prompt = prompt,
    response_format = response_format,
    temperature = temperature,
    timestamp_granularities = timestamp_granularities
  ) |>
    compact()
  oai_query(
    ep = c("audio", "transcriptions"),
    method = "POST",
    body = body,
    encode = "multipart",
    headers = list("Content-Type" = "multipart/form-data"),
    .classify_response = .classify_response
  )
}

#' @description * `oai_create_translation()`: Translates audio into English.
#' @param file Character. The audio file object (not file name) translate, in one of these formats: flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, or webm.
#' @param model Character. ID of the model to use. Only whisper-1 (which is powered by our open source Whisper V2 model) is currently available.
#' @param prompt Character. An optional text to guide the model's style or continue a previous audio segment. The prompt should be in English.
#' @param response_format Character. The format of the output, in one of these options: json, text, srt, verbose_json, or vtt.
#' @param temperature Numeric. The sampling temperature, between 0 and 1. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. If set to 0, the model will use log probability to automatically increase the temperature until certain thresholds are hit.
#' @return Returns the translated text.
#' @export
#' @rdname audio
oai_create_translation <- function(file,
                                   model = "whisper-1",
                                   prompt = NULL,
                                   response_format = c("json", "text", "srt", "verbose_json", "vtt"),
                                   temperature = NULL,
                                   name = NULL,
                                   .classify_response = TRUE
                                   ) {
  response_format <- match.arg(response_format)
  body <- list(
    file = form_file(file, name = name),
    model = model,
    prompt = prompt,
    response_format = response_format,
    temperature = temperature
  ) |>
    compact()
  oai_query(
    ep = c("audio", "translations"),
    method = "POST",
    body = body,
    encode = "multipart",
    headers = list("Content-Type" = "multipart/form-data"),
    .classify_response = .classify_response
  )
}

#' Transcription object
#' Represents a transcription response returned by model, based on the provided input.
#' @field text Character. The transcribed text.
#' @export
#' @rdname audio_transcription
Transcription <- R6Class(
  "Transcription",
  portable = FALSE,
  public = list(
    #' @description Initialize the Transcription object.
    #' @param resp List. The response object.
    #' @param ... unused.
    initialize = function(..., resp = NULL) {
      if (!is.null(resp)) {
        self$text <- resp$text
      }
    },
    text = NULL
  )
)

#' Verbose transcription object
#' Represents a verbose json transcription response returned by model, based on the provided input.
#' @field language Character. The language of the input audio.
#' @field duration Character. The duration of the input audio.
#' @field text Character. The transcribed text.
#' @field words List. Extracted words and their corresponding timestamps.
#' @field segments List. Segments of the transcribed text and their corresponding details.
#' @export
#' @rdname audio_transcription
VerboseTranscription <- R6Class(
  "VerboseTranscription",
  portable = FALSE,
  public = list(
    #' @description Initialize the VerboseTranscription object.
    #' @param resp List. The response object.
    #' @param ... unused.
    initialize = function(..., resp = NULL) {
      if (!is.null(resp)) {
        self$language <- resp$language
        self$duration <- resp$duration
        self$text <- resp$text
        self$words <- resp$words
        self$segments <- resp$segments
      }
    },
    language = NULL,
    duration = NULL,
    text = NULL,
    words = NULL,
    segments = NULL
  )
)
