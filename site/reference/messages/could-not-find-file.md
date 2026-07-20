---
message: "could not find file \"%s\": %m"
slug: could-not-find-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_waldump/pg_waldump.c:393"
reproduced: false
---

# `could not find file "%s": %m`

## What it means

`pg_waldump` could not open a WAL file it was asked to read. The `%s` names the file and `%m` gives the OS error.

## When it happens

It happens when `pg_waldump` is pointed at a specific WAL segment that is absent from the directory, or the path is wrong.

## How to fix

Check the file name and directory. Confirm the requested WAL segment exists where `pg_waldump` is looking, and supply the correct path or a start point that matches the segments present.

## Example

*Illustrative* — a WAL segment pg_waldump cannot open.

```text
pg_waldump: fatal: could not find file "000000010000000000000005": No such file or directory
```

## Related

- [could not find any WAL file](./could-not-find-any-wal-file.md)
- [could not find file in archive](./could-not-find-file-in-archive.md)
