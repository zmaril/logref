---
message: "backup label too long (max %d bytes)"
slug: backup-label-too-long-max-bytes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:9477"
reproduced: false
---

# `backup label too long (max %d bytes)`

## What it means

A label string supplied to a backup function exceeds the maximum length allowed. The placeholder is the byte limit. Backup labels are stored in a fixed-width field, so overly long labels are rejected.

## When it happens

It occurs when `pg_backup_start('label')` or `pg_basebackup --label` is given a label longer than the permitted size.

## How to fix

Shorten the label to within the stated byte limit. A concise label that identifies the backup is enough; move any longer description into your own backup catalog or file names.

## Example

*Illustrative* — an overlong backup label.

```text
ERROR:  backup label too long (max 1024 bytes)
```

## Related

- [backup label buffer too small](./backup-label-buffer-too-small.md)
- [backup is not in progress](./backup-is-not-in-progress.md)
