---
message: "checksum error occurred"
slug: checksum-error-occurred
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2194"
reproduced: false
---

# `checksum error occurred`

## What it means

A client tool detected a data-page checksum error while reading blocks. A block's stored checksum did not match its contents, which signals that the page was corrupted or altered outside the server.

## When it happens

It occurs in tools such as `pg_basebackup` or `pg_verifybackup` when checksum verification finds a mismatched page during a backup or verification pass.

## How to fix

Investigate the affected file and block for storage corruption. Check hardware and filesystem health, restore the file from a good backup if needed, and rerun the tool once the source is clean.

## Example

*Illustrative* — a checksum error during a client operation.

```text
pg_basebackup: error: checksum error occurred
```

## Related

- [checksum verification failed in file block calculated checksum but block](./checksum-verification-failed-in-file-block-calculated-checksum-but-block.md)
- [checksum verification failure during base backup](./checksum-verification-failure-during-base-backup.md)
