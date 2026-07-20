---
message: "checksum verification failed in file \"%s\", block %u: calculated checksum %X but block contains %X"
slug: checksum-verification-failed-in-file-block-calculated-checksum-but-block
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_checksums/pg_checksums.c:232"
reproduced: false
---

# `checksum verification failed in file "%s", block %u: calculated checksum %X but block contains %X`

## What it means

A client tool computed a data-page checksum that differed from the one stored in the block. The named file and block are corrupt, or the page was written by something other than the server.

## When it happens

It occurs in `pg_basebackup` or `pg_verifybackup` when a specific block fails checksum verification during a backup or verification pass.

## How to fix

Note the file and block reported, and investigate that page for storage corruption. Check hardware and filesystem health, restore the file from a good backup, and rerun the verification.

## Example

*Illustrative* — a specific block checksum failure.

```text
pg_basebackup: error: checksum verification failed in file "base/5/16384", block 42: calculated checksum A1B2 but block contains C3D4
```

## Related

- [checksum verification failure during base backup](./checksum-verification-failure-during-base-backup.md)
- [checksum error occurred](./checksum-error-occurred.md)
