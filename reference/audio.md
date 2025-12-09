# Audio API

Turn audio into text or text into audio.

- `oai_create_speec()`: Generates audio from the input text.

&nbsp;

- `oai_create_transcription()`: Transcribes audio into the input
  language.

&nbsp;

- `oai_create_translation()`: Translates audio into English.

## Usage

``` r
oai_create_speech(
  input,
  path,
  model = c("tts-1", "tts-1-hd", "gpt-4o-mini-tts"),
  voice = c("alloy", "ash", "ballad", "coral", "echo", "fable", "onyx", "nova", "sage",
    "shimmer", "verse"),
  instruction = NULL,
  response_format = c("mp3", "opus", "aac", "flac", "wav", "pcm"),
  speed = NULL,
  .async = FALSE
)

oai_create_transcription(
  file,
  model = "whisper-1",
  language = NULL,
  prompt = NULL,
  response_format = c("json", "text", "srt", "verbose_json", "vtt"),
  temperature = NULL,
  timestamp_granularities = NULL,
  name = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_create_translation(
  file,
  model = "whisper-1",
  prompt = NULL,
  response_format = c("json", "text", "srt", "verbose_json", "vtt"),
  temperature = NULL,
  name = NULL,
  .classify_response = TRUE,
  .async = FALSE
)
```

## Arguments

- input:

  Character. The text to generate audio for. The maximum length is 4096
  characters.

- path:

  Character. The path to save the audio file.

- model:

  Character. ID of the model to use. Only whisper-1 (which is powered by
  our open source Whisper V2 model) is currently available.

- voice:

  Character. The voice to use when generating the audio. Supported
  voices are alloy, ash, coral, echo, fable, onyx, nova, sage and
  shimmer. Previews of the voices are available in the Text to speech
  guide.

- instruction:

  Character. Control the voice of your generated audio with additional
  instructions. Does not work with `tts-1` or `tts-1-hd`.

- response_format:

  Character. The format of the output, in one of these options: json,
  text, srt, verbose_json, or vtt.

- speed:

  Numeric. The speed of the generated audio. Select a value from 0.25 to
  4.0. 1.0 is the default.

- .async:

  Logical. If `TRUE`, the request is performed asynchronously.

- file:

  Character. The audio file object (not file name) translate, in one of
  these formats: flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, or webm.

- language:

  Character. The language of the input audio. Supplying the input
  language in ISO-639-1 format will improve accuracy and latency.

- prompt:

  Character. An optional text to guide the model's style or continue a
  previous audio segment. The prompt should be in English.

- temperature:

  Numeric. The sampling temperature, between 0 and 1. Higher values like
  0.8 will make the output more random, while lower values like 0.2 will
  make it more focused and deterministic. If set to 0, the model will
  use log probability to automatically increase the temperature until
  certain thresholds are hit.

- timestamp_granularities:

  List. The timestamp granularities to populate for this transcription.
  response_format must be set verbose_json to use timestamp
  granularities. Either or both of these options are supported: word, or
  segment. Note: There is no additional latency for segment timestamps,
  but generating word timestamps incurs additional latency.

- name:

  Character. The file name to use for the upload.

- .classify_response:

  Logical. If `TRUE` (default), the response is classified as an R6
  object. If `FALSE`, the response is returned as a list.

## Value

Returns the audio file content.

Returns the transcription object or a verbose transcription object.

Returns the translated text.
