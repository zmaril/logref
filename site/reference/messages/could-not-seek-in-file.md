---
message: "could not seek in file \"%s\": %m"
slug: could-not-seek-in-file
passthrough: false
api: [ereport, pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/genfile.c:129"
  - "postgres/src/bin/pg_rewind/parsexlog.c:362"
reproduced: false
---

# `could not seek in file "%s": %m`

## What it means

A seek within a file failed. The `%s` is the path and the `%m` is the operating-system error. The process could not reposition to the offset it needed — on the server (for example `pg_read_file`) or in `pg_rewind`.

## When it happens

An I/O error, a truncated file, or a bad offset triggered the failed seek while reading a file's contents.

## How to fix

Read the trailing error. Check the file exists at the expected size and that storage is healthy. For a truncated or corrupt file, restore it from a known-good copy.

## Example

*Illustrative* — a seek past the end of a short file.

```text
ERROR:  could not seek in file "pg_wal/000000010000000000000003": Invalid argument
```

## Related

- [could not seek to end of file](./could-not-seek-to-end-of-file.md)
- [could not read blocks in file](./could-not-read-blocks-in-file.md)
