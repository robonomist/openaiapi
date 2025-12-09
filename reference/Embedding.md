# R6 class representing an Embedding in the OpenAI API

R6 class representing an Embedding in the OpenAI API

R6 class representing an Embedding in the OpenAI API

## Super class

`openaiapi::Utils` -\> `Embedding`

## Public fields

- `embedding`:

  The embedding vector.

- `index`:

  The index of the embedding in the list of embeddings.

## Methods

### Public methods

- [`Embedding$new()`](#method-Embedding-new)

- [`Embedding$print()`](#method-Embedding-print)

- [`Embedding$clone()`](#method-Embedding-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize an Embedding object

#### Usage

    Embedding$new(input, model, ..., resp = NULL, .async = FALSE)

#### Arguments

- `input`:

  Character. Input text to embed.

- `model`:

  Character. ID of the model used to generate the embedding.

- `...`:

  Additional arguments to be passed to the API functions.

- `resp`:

  A list. The response object from the OpenAI API containing details of
  the embedding.

- `.async`:

  Logical. If TRUE, the function will return a promise.

#### Returns

A new instance of an Embedding object.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print the Embedding object

#### Usage

    Embedding$print(...)

#### Arguments

- `...`:

  Unused.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Embedding$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
