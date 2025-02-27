% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/query.R
\name{oai_set_api_key}
\alias{oai_set_api_key}
\title{Set OpenAI API key}
\usage{
oai_set_api_key(api_key)
}
\arguments{
\item{api_key}{A character string with the OpenAI API key.}
}
\description{
To use the OpenAI API, you need to have an API key. You can get one by signing up at \href{https://platform.openai.com/}{OpenAI}.
}
\details{
Alternatively, you can set the \code{OPENAI_API_KEY} environment variable, which is read at package load time.
}
