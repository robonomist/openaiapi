# Transcription object Represents a transcription response returned by model, based on the provided input.

Transcription object Represents a transcription response returned by
model, based on the provided input.

Transcription object Represents a transcription response returned by
model, based on the provided input.

Verbose transcription object Represents a verbose json transcription
response returned by model, based on the provided input.

Verbose transcription object Represents a verbose json transcription
response returned by model, based on the provided input.

## Public fields

- `text`:

  Character. The transcribed text.

## Methods

### Public methods

- [`Transcription$new()`](#method-Transcription-new)

- [`Transcription$clone()`](#method-Transcription-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize the Transcription object.

#### Usage

    Transcription$new(..., resp = NULL)

#### Arguments

- `...`:

  unused.

- `resp`:

  List. The response object.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Transcription$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Public fields

- `language`:

  Character. The language of the input audio.

- `duration`:

  Character. The duration of the input audio.

- `text`:

  Character. The transcribed text.

- `words`:

  List. Extracted words and their corresponding timestamps.

- `segments`:

  List. Segments of the transcribed text and their corresponding
  details.

## Methods

### Public methods

- [`VerboseTranscription$new()`](#method-VerboseTranscription-new)

- [`VerboseTranscription$clone()`](#method-VerboseTranscription-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize the VerboseTranscription object.

#### Usage

    VerboseTranscription$new(..., resp = NULL)

#### Arguments

- `...`:

  unused.

- `resp`:

  List. The response object.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    VerboseTranscription$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
