# Create a sandbox environment for function tools

For convenience, all function tools calling methods, by default, are
evaluated in the parent frame. This poses a security risk, as the
function tools call, which is receved from the API, can access the
environment of the caller (and thus potentially any function or variable
in R). This function creates a sandbox environment for the function
tools, which is a copy of the parent frame, but without any unnecessary
variables or functions from the parent frame. This sandbox environment
can be used to evaluate the function tools in a safe manner.

## Usage

``` r
make_sandbox_env(tools, env = parent.frame())
```

## Arguments

- tools:

  A list of function tools.

- env:

  The environment to use to find the function tools. Defaults to the
  parent frame.
