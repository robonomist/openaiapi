# Common parameters

Common parameters

## Arguments

- limit:

  Integer. Optional. A limit on the number of objects to be returned.
  Limit can range between 1 and 100, and the default is 20.

- order:

  Character. Optional. Sort order by the created_at timestamp of the
  objects. `"asc"` for ascending order and `"desc"` for descending
  order.

- after:

  Character. Optional. A cursor for use in pagination. `after` is an
  object ID that defines your place in the list. For instance, if you
  make a list request and receive 100 objects, ending with obj_foo, your
  subsequent call can include `after = "obj_foo"` in order to fetch the
  next page of the list.

- before:

  Character. Optional. A cursor for use in pagination. before is an
  object ID that defines your place in the list. For instance, if you
  make a list request and receive 100 objects, ending with obj_foo, your
  subsequent call can include `before = "obj_foo"` in order to fetch the
  previous page of the list.

- metadata:

  List. Optional. A named list of at most 16 key-value pairs that can be
  attached to an object. This can be useful for storing additional
  information about the object in a structured format, and querying for
  objects via API or the dashboard.

- .classify_response:

  Logical. If `TRUE` (default), the response is classified as an R6
  object. If `FALSE`, the response is returned as a list.

- stream:

  not yet implemented.

- .async:

  Logical. If `TRUE`, the request is performed asynchronously.
