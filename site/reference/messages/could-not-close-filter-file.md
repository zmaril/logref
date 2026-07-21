---
message: "could not close filter file \"%s\": %m"
slug: could-not-close-filter-file
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/filter.c:71"
reproduced: false
---

# `could not close filter file "%s": %m`

## What it means

`pg_dump`/`pg_restore` could not close the `--filter` file it read object patterns from. The `%m` reason gives the OS error. The close failed.

## When it happens

It happens when a `--filter` file cannot be closed after reading, typically due to a filesystem-level problem.

## How to fix

Check the filter file's filesystem for errors and permissions. The read itself likely succeeded; a close failure points at the underlying storage — resolve it and rerun if needed.

## Example

*Illustrative* — a failed filter-file close.

```text
pg_dump: error: could not close filter file "filters.txt": ...
```

## Related

- [could not close input file](./could-not-close-input-file.md)
- [could not close archive location](./could-not-close-archive-location.md)
