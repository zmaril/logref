---
message: "could not find redo location %X/%08X referenced by checkpoint record at %X/%08X"
slug: could-not-find-redo-location-referenced-by-checkpoint-record-at
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/access/transam/xlogrecovery.c:593"
  - "postgres/src/backend/access/transam/xlogrecovery.c:751"
reproduced: false
---

# `could not find redo location %X/%08X referenced by checkpoint record at %X/%08X`

## What it means

FATAL startup error. During recovery, the server read a checkpoint record that points at a redo start location whose WAL is not available. The placeholders are the redo location and the checkpoint record's location. Recovery cannot begin without the WAL the checkpoint references.

## When it happens

Starting a cluster whose `pg_wal` is missing the WAL segment containing the checkpoint's redo point — because WAL was deleted, an incomplete backup omitted it, or the archive cannot supply it.

## How to fix

Restore the missing WAL so recovery can reach the redo point — from the WAL archive, a base backup, or a source that has it. Do not remove files from `pg_wal` manually. If restoring from backup, ensure `restore_command` can fetch the needed segments. As a last resort on an unrecoverable cluster, `pg_resetwal` discards WAL but risks data loss and should follow expert guidance.

## Example

*Illustrative* — a checkpoint referencing missing WAL.

```text
FATAL:  could not find redo location 0/9000060 referenced by checkpoint record at 0/90000D8
```

## Related

- [could not close WAL segment](./could-not-close-wal-segment.md)
- [could not find record for logical decoding](./could-not-find-record-for-logical-decoding.md)
