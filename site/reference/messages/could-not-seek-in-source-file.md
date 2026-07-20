---
message: "could not seek in source file: %m"
slug: could-not-seek-in-source-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/local_source.c:144"
reproduced: false
---

# `could not seek in source file: %m`

## What it means

`pg_rewind` could not seek within a file in the source (the server or directory it is rewinding from). The trailing text is the operating-system error.

## When it happens

It fires during `pg_rewind` while it reads blocks from the source to copy into the target and cannot reposition within a source file.

## How to fix

Read the OS error. An I/O fault points at the source storage; a permission problem means the user running `pg_rewind` cannot access the source data directory. When the source is a live server, make sure the connection is stable and the server is healthy. Fix the reported cause and rerun.

## Example

*Illustrative* — a seek in a source file failed.

```text
pg_rewind: error: could not seek in source file: Input/output error
```

## Related

- [could not seek in target file](./could-not-seek-in-target-file.md)
- [data file in source is not a regular file](./data-file-in-source-is-not-a-regular-file.md)
