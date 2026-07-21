---
message: "actual file length (%lld) does not match expected (%lld)"
slug: actual-file-length-does-not-match-expected
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:1026"
reproduced: false
---

# `actual file length (%lld) does not match expected (%lld)`

## What it means

A file the server read was a different size than metadata said it should be, so the file is truncated or padded relative to what was recorded — a sign of a damaged or incomplete file.

## When it happens

It is raised as fatal when validating a file (for example during backup manifest checks or WAL/relation handling) and the on-disk length disagrees with the expected length.

## How to fix

Treat the file as corrupt or incomplete. Check storage health and any recent crash or out-of-space event, restore the affected file from a known-good backup, and verify the integrity of the whole backup or data directory it came from. A length mismatch usually means the write was interrupted or the media is faulty.

## Example

*Illustrative* — a file shorter than expected.

```text
FATAL:  actual file length (1024) does not match expected (8192)
```

## Related

- [archives must precede manifest](./archives-must-precede-manifest.md)
- [access to noncontiguous page in hash index](./access-to-noncontiguous-page-in-hash-index.md)
