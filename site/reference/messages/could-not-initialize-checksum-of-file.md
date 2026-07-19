---
message: "could not initialize checksum of file \"%s\""
slug: could-not-initialize-checksum-of-file
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/backup/basebackup.c:1083"
  - "postgres/src/backend/backup/basebackup.c:1590"
reproduced: false
---

# `could not initialize checksum of file "%s"`

## What it means

Internal error during a base backup. The server could not initialize the checksum state for a file it was about to stream into the backup manifest. The `%s` is the file path. It reflects a failure setting up the checksum algorithm, not a bad checksum value.

## When it happens

It fires inside `BASE_BACKUP` manifest generation, typically when the configured checksum algorithm could not be started for a file. Ordinary queries do not reach it.

## How to fix

This is an internal guard. Check the backup manifest checksum setting is valid and retry the backup. If it recurs, capture the server log and the manifest options and report it.

## Example

*Illustrative* — checksum setup failed for a manifest entry.

```text
ERROR:  could not initialize checksum of file "base/16384/1259"
```

## Related

- [could not stat file or directory](./could-not-stat-file-or-directory.md)
- [could not fsync file](./could-not-fsync-file-5db846.md)
