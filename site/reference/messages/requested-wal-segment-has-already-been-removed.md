---
message: "requested WAL segment %s has already been removed"
slug: requested-wal-segment-has-already-been-removed
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:3792"
  - "postgres/src/backend/access/transam/xlogutils.c:842"
  - "postgres/src/backend/replication/walsender.c:3327"
reproduced: false
---

# `requested WAL segment %s has already been removed`

## What it means

A process asked for a WAL segment that the server has already recycled or removed. Once WAL is no longer needed for recovery or retained by a slot, the server discards it, and the requested segment is past that point.

## When it happens

A standby or a logical/physical replication consumer falls far enough behind that the primary recycles WAL it still needs, or a tool requests an old segment that retention settings did not keep. Insufficient `wal_keep_size` or a missing replication slot is the usual cause.

## How to fix

Keep the needed WAL available. Use a replication slot so the primary retains WAL until the consumer has it, raise `wal_keep_size`, or archive WAL and let the standby fetch missing segments via `restore_command`. If a standby has already fallen too far behind, it may need to be re-seeded from a fresh base backup.

## Example

*Illustrative* — a consumer requesting recycled WAL.

```text
ERROR:  requested WAL segment 000000010000000000000023 has already been removed
```

## Related

- [requested wal segment has already been removed](./requested-wal-segment-has-already-been-removed.md)
- [required wal directory does not exist](./required-wal-directory-does-not-exist.md)
