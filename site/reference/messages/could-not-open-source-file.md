---
message: "could not open source file \"%s\": %m"
slug: could-not-open-source-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/local_source.c:88"
  - "postgres/src/bin/pg_rewind/local_source.c:140"
reproduced: false
---

# `could not open source file "%s": %m`

## What it means

`pg_rewind` could not open a file in the source data directory it was reading from. The `%s` is the path and the `%m` is the operating-system error. The rewind cannot copy that file.

## When it happens

The source directory path was wrong or partly unreadable, a file was removed mid-run, or permissions on the source cluster blocked the read.

## How to fix

Verify the `--source-pgdata` path and that the rewind user can read the whole source directory tree. Ensure the source cluster is not being modified underneath the run.

## Example

*Illustrative* — a source-cluster file could not be opened.

```text
pg_rewind: error: could not open source file "global/pg_control": Permission denied
```

## Related

- [could not open input file](./could-not-open-input-file-d824fe.md)
- [duplicate source file](./duplicate-source-file.md)
