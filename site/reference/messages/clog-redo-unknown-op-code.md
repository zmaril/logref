---
message: "clog_redo: unknown op code %u"
slug: clog-redo-unknown-op-code
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/transam/clog.c:1114"
reproduced: false
---

# `clog_redo: unknown op code %u`

## What it means

An internal guard fired during WAL replay: the commit-log redo routine met a record whose operation code it does not recognize. A valid WAL stream contains only known op codes, so this signals a corrupt or incompatible record.

## When it happens

It is reached during recovery or standby replay when reading a `clog` WAL record with an unexpected op code, usually from WAL corruption or a version mismatch.

## How to fix

This points to damaged or mismatched WAL. Confirm the server version matches the WAL source, check storage integrity, and restore from a known-good backup and WAL archive if the stream is corrupt.

## Example

*Illustrative* — an unknown clog redo op code.

```text
PANIC:  clog_redo: unknown op code 42
```

## Related

- [checksum mismatch for replication slot file is should be](./checksum-mismatch-for-replication-slot-file-is-should-be.md)
- [close of when was expected](./close-of-when-was-expected.md)
