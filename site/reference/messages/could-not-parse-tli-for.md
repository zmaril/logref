---
message: "%s: could not parse TLI for %s"
slug: could-not-parse-tli-for
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/backup_label.c:76"
reproduced: false
---

# `%s: could not parse TLI for %s`

## What it means

`pg_combinebackup` read a backup's label to learn its timeline identifier (TLI) and could not parse it. The `%s` values give the context and the backup. The TLI identifies which timeline a backup belongs to.

## When it happens

It happens while combining incremental backups, when a `backup_label` file's timeline field is not in the expected form — usually a corrupted or hand-edited backup label, or an incompatible backup.

## How to fix

Make sure each backup passed to `pg_combinebackup` is intact and unedited, produced by a compatible `pg_basebackup`, and that its `backup_label` is not corrupted. Re-taking the affected backup resolves a damaged label.

## Example

*Illustrative* — an unparsable timeline in a backup label.

```text
pg_combinebackup: fatal: /backups/inc1: could not parse TLI for backup_label
```

## Related

- [could not parse next timeline's starting point](./could-not-parse-next-timeline-s-starting-point.md)
- [could not read file: read of](./could-not-read-file-read-of-b21beb.md)
