# CSV age filter

The filter is implemented in `src/filter-by-min-age.c`. It currently uses
commas as its CSV delimiter.

## Run the tests

The tests require Bash and `clang++`. From the repository root, run:

```sh
bash tests/test-filter-by-min-age.sh
```

The script compiles the filter in a temporary directory, tests valid rows,
and checks that rows with a missing age or a blank line are handled without
crashing.
