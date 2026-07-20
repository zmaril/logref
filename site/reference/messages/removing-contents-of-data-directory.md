---
message: "removing contents of data directory \"%s\""
slug: removing-contents-of-data-directory
passthrough: false
api: [pg_log_info]
level: [INFO]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:791"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:252"
reproduced: false
---

# `removing contents of data directory "%s"`

## What it means

A tool is emptying the contents of the target data directory while leaving the directory itself in place.

## When it happens

It is printed at INFO by tools such as `pg_basebackup` or `pg_rewind` when they clear an existing target before writing fresh files into it.

## Is this a problem?

This is expected when you asked the tool to overwrite an existing directory. Make sure the path is the one you meant to erase — the previous contents are being deleted. There is nothing to fix if the target was correct.

## Example

*Illustrative* — a base backup clearing its target.

```text
INFO:  removing contents of data directory "/var/lib/pg/standby"
```

## Related

- [removing data directory](./removing-data-directory.md)
- [removing contents of WAL directory](./removing-contents-of-wal-directory.md)
