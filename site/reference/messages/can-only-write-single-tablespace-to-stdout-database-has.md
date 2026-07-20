---
message: "can only write single tablespace to stdout, database has %d"
slug: can-only-write-single-tablespace-to-stdout-database-has
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2081"
reproduced: false
---

# `can only write single tablespace to stdout, database has %d`

## What it means

`pg_basebackup` was asked to write a tar-format backup to standard output, but the cluster has more than one tablespace. The placeholder is the tablespace count. A single output stream can carry only one tablespace's tar file.

## When it happens

It occurs when running `pg_basebackup -Ft -D -` (tar format to stdout) against a cluster that has extra tablespaces beyond the default.

## How to fix

Write to a directory instead of stdout with `-D some/dir`, which produces one tar file per tablespace, or use plain format. Streaming to stdout only works when the cluster has a single tablespace.

## Example

*Illustrative* — tar-to-stdout with multiple tablespaces.

```text
FATAL:  can only write single tablespace to stdout, database has 2
```

## Related

- [can only reopen input archives](./can-only-reopen-input-archives.md)
- [backup failed](./backup-failed.md)
