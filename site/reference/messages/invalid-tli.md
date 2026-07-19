---
message: "%s: invalid TLI"
slug: invalid-tli
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/backup_label.c:79"
  - "postgres/src/bin/pg_combinebackup/backup_label.c:98"
reproduced: false
---

# `%s: invalid TLI`

## What it means

A tool or recovery step read a timeline id (TLI) that is not valid — zero or otherwise out of range. Timeline ids number the branches of WAL history and must be positive. The placeholder is the tool name.

## When it happens

It arises in recovery/backup tooling (for example `pg_waldump`, `pg_rewind`, or archive recovery) when a timeline value parsed from a filename, history file, or control data is malformed.

## How to fix

Confirm the WAL files, history files, and control data are intact and from the expected cluster. A bad timeline value usually means corrupted or mismatched WAL/backup inputs; restore consistent copies from your archive or source cluster.

## Example

*Illustrative* — a malformed timeline id.

```text
FATAL:  pg_rewind: invalid TLI
```

## Related

- [invalid data in history file](./invalid-data-in-history-file-df2123.md)
- [invalid WAL location](./invalid-wal-location.md)
