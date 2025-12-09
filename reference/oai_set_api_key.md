# Set OpenAI API key

To use the OpenAI API, you need to have an API key. You can get one by
signing up at [OpenAI](https://platform.openai.com/).

## Usage

``` r
oai_set_api_key(api_key)
```

## Arguments

- api_key:

  A character string with the OpenAI API key.

## Details

Alternatively, you can set the `OPENAI_API_KEY` environment variable,
which is read at package load time.
