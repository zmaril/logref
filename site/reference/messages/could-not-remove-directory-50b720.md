---
message: "could not remove directory \"%s\""
slug: could-not-remove-directory-50b720
passthrough: false
api: [ereport]
level: [WARNING]
call_sites:
  - "postgres/src/backend/replication/slot.c:1138"
  - "postgres/src/backend/replication/slot.c:2428"
  - "postgres/src/backend/replication/slot.c:2821"
reproduced: false
---

# `could not remove directory "%s"`

## What it means

The server could not remove a directory it was cleaning up, most often a replication-slot directory. Raised as a warning, it means cleanup left the directory behind but the operation otherwise proceeded.

## When it happens

Dropping a replication slot or cleaning up slot data when the directory could not be removed — files still open, permission problems, or an interfering process holding the directory.

## Is this a problem?

This is a warning, not a failure of the main operation. Check why the directory could not be removed: leftover files, permissions, or another process. A stale slot directory can usually be cleaned up manually once nothing holds it, but confirm the slot is truly gone before removing files by hand.

## Example

*Illustrative* — a slot directory left behind.

```text
WARNING:  could not remove directory "pg_replslot/old_slot"
```

## Related

- [could not remove file](./could-not-remove-file-cd3a60.md)
- [replication slot does not exist](./replication-slot-does-not-exist.md)
