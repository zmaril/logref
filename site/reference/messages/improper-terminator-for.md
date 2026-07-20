---
message: "%s: improper terminator for %s"
slug: improper-terminator-for
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/backup_label.c:69"
  - "postgres/src/bin/pg_combinebackup/backup_label.c:88"
reproduced: false
---

# `%s: improper terminator for %s`

## What it means

`pg_combinebackup` found a malformed terminator while parsing a backup label. The `%s` values are the context and the field. The label file did not end a field where the parser expected.

## When it happens

The `backup_label` in one of the input backups was truncated or corrupted, so its structured content did not parse.

## How to fix

Confirm the input backups are complete and intact — re-copy a truncated one. If a `backup_label` is genuinely corrupt, re-take that backup. Then rerun `pg_combinebackup`.

## Example

*Illustrative* — a malformed backup-label field.

```text
pg_combinebackup: error: backup_label: improper terminator for START WAL LOCATION
```

## Related

- [could not write file: wrote of](./could-not-write-file-wrote-of-c8a991.md)
- [error while copying file range from to](./error-while-copying-file-range-from-to.md)
