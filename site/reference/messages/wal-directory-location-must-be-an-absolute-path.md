---
message: "WAL directory location must be an absolute path"
slug: wal-directory-location-must-be-an-absolute-path
passthrough: false
api: [pg_fatal, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:2993"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2759"
reproduced: false
---

# `WAL directory location must be an absolute path`

## What it means

A tool was given a WAL-directory location as a relative path, but the WAL directory must be specified as an absolute path.

## When it happens

It arises from `initdb --waldir` and `pg_basebackup --waldir` (and related paths) when the supplied WAL location is not an absolute path.

## How to fix

Pass an absolute path for the WAL directory, beginning at the filesystem root. Resolve any relative or `~`-based path to its full form before passing it to the tool.

## Example

*Illustrative* — a relative WAL directory.

```text
ERROR:  WAL directory location must be an absolute path
```

## Related

- [creating missing WAL directory "%s"](./creating-missing-wal-directory.md)
- [WAL level not sufficient for making an online backup](./wal-level-not-sufficient-for-making-an-online-backup.md)
