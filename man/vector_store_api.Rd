% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vector_stores.R
\name{vector_store_api}
\alias{vector_store_api}
\alias{oai_create_vector_store}
\alias{oai_list_vector_stores}
\alias{oai_retrieve_vector_store}
\alias{oai_modify_vector_store}
\alias{oai_delete_vector_store}
\alias{oai_search_vector_store}
\title{Vector Store API}
\usage{
oai_create_vector_store(
  file_ids = NULL,
  name = NULL,
  expires_after = NULL,
  chunking_strategy = NULL,
  metadata = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_list_vector_stores(
  limit = NULL,
  order = NULL,
  after = NULL,
  before = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_retrieve_vector_store(
  vector_store_id,
  .classify_response = TRUE,
  .async = FALSE
)

oai_modify_vector_store(
  vector_store_id,
  name = NULL,
  expires_after = NULL,
  metadata = NULL,
  .classify_response = TRUE,
  .async = FALSE
)

oai_delete_vector_store(vector_store_id, .async = FALSE)

oai_search_vector_store(
  vector_store_id,
  query,
  filters = NULL,
  max_num_results = NULL,
  ranking_options = NULL,
  rewrite_query = NULL,
  .classify_response = TRUE,
  .async = FALSE
)
}
\arguments{
\item{file_ids}{Character. Optional. A vector of file IDs to include in the vector store.}

\item{name}{Character. Optional. A name for the vector store.}

\item{expires_after}{List. Optional. Expiration time for the vector store in seconds.}

\item{chunking_strategy}{List. Optional. Strategy for chunking data.}

\item{metadata}{List. Optional. Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format. Keys can be a maximum of 64 characters long and values can be a maximum of 512 characters long.}

\item{.classify_response}{Logical. If \code{TRUE} (default), the response is classified as an R6 object. If \code{FALSE}, the response is returned as a list.}

\item{.async}{Logical. If \code{TRUE}, the request is performed asynchronously.}

\item{limit}{Integer. Optional. A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.}

\item{order}{Character. Optional. Sort order by the created_at timestamp of the objects. \code{"asc"} for ascending order and \code{"desc"} for descending order.}

\item{after}{Character. Optional. A cursor for use in pagination. \code{after} is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include \code{after = "obj_foo"} in order to fetch the next page of the list.}

\item{before}{Character. Optional. A cursor for use in pagination. before is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include \code{before = "obj_foo"} in order to fetch the previous page of the list.}

\item{vector_store_id}{Character. The ID of the vector store to retrieve.}

\item{query}{Character. The query string for the search.}

\item{filters}{List. Optional. A filter to apply based on file attributes.}

\item{max_num_results}{Integer. Optional. The maximum number of results to return (1-50).}

\item{ranking_options}{List. Optional. Ranking options for the search.}

\item{rewrite_query}{Logical. Optional. Whether to rewrite the natural language query for vector search.}
}
\value{
VectorStore R6 object.

\code{oai_list_vector_stores()} returns a list of VectorStore objects.

Deletion status.

\itemize{
\item \code{oai_search_vector_store()} returns a list of search results from the vector store.
}
}
\description{
Vector stores are used to store files for use by the \code{file_search} tool.

\itemize{
\item \code{oai_create_vector_store()}: Create a new vector store.
}

\itemize{
\item \code{oai_list_vector_stores()}: List vector stores.
}

\itemize{
\item \code{oai_retrieve_vector_store()}: Retrieve a specific vector store.
}

\itemize{
\item \code{oai_modify_vector_store()}: Modify a specific vector store.
}

\itemize{
\item \code{oai_delete_vector_store()}: Delete a specific vector store.
}

\itemize{
\item \code{oai_search_vector_store()}: Search a specific vector store.
}
}
