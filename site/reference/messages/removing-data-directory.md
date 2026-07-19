---
message: "removing data directory \"%s\""
slug: removing-data-directory
passthrough: false
api: [pg_log_info]
level: [INFO]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:785"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:246"
reproduced: false
---

# `removing data directory "%s"`

## What it means

A tool is deleting the target data directory entirely, including the directory itself.

## When it happens

It is printed at INFO when a tool such as `pg_basebackup` removes a directory it created (for example while cleaning up after a failure) or when clearing a target it fully owns.

## Is this a problem?

Expected during cleanup or a fresh overwrite. Verify the path was the intended one. If this follows an error, the earlier failure is the thing to investigate, not the removal itself.

## Example

*Illustrative* — a tool removing a directory it owns.

```text
INFO:  removing data directory "/var/lib/pg/tmp_target"
```

## Related

- [removing contents of data directory](./removing-contents-of-data-directory.md)
- [removing WAL directory](./removing-wal-directory.md)
