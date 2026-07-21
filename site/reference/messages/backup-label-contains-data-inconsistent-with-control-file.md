---
message: "backup_label contains data inconsistent with control file"
slug: backup-label-contains-data-inconsistent-with-control-file
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/access/transam/xlogrecovery.c:941"
reproduced: false
---

# `backup_label contains data inconsistent with control file`

## What it means

During recovery the server compared the `backup_label` file with `pg_control` and found values that disagree. The two must be consistent for the server to know where in the WAL to begin replay.

## When it happens

It occurs at startup after restoring a base backup when the `backup_label` and the control file come from different backups or one of them was altered or corrupted.

## How to fix

Restore a matched `backup_label` and control file from the same backup. Do not hand-edit or remove `backup_label` from a restored backup unless you know exactly what you are doing; take a fresh backup if the pair cannot be reconciled.

## Example

*Illustrative* — a mismatched label at startup.

```text
FATAL:  backup_label contains data inconsistent with control file
```

## Related

- [backup at starts at lsn but expected](./backup-at-starts-at-lsn-but-expected.md)
- [bogus data in lock file](./bogus-data-in-lock-file.md)
