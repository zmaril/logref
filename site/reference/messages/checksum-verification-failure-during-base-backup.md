---
message: "checksum verification failure during base backup"
slug: checksum-verification-failure-during-base-backup
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/backup/basebackup.c:665"
reproduced: false
---

# `checksum verification failure during base backup`

## What it means

A base backup detected one or more data-page checksum failures while copying the cluster. The server reports that the backup encountered corrupt pages, which are recorded as damaged data.

## When it happens

It occurs during a server-side base backup when page checksums are enabled and one or more blocks fail verification as they are read.

## How to fix

Treat the affected pages as corruption. Review the server log for the specific files and blocks, check storage health, and repair or restore the damaged relations from a good backup before relying on the cluster.

## Example

*Illustrative* — checksum failures during a base backup.

```text
ERROR:  checksum verification failure during base backup
```

## Related

- [checksum verification failed in file block calculated checksum but block](./checksum-verification-failed-in-file-block-calculated-checksum-but-block.md)
- [checksum error occurred](./checksum-error-occurred.md)
