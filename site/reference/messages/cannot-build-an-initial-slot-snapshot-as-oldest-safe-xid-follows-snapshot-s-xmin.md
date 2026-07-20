---
message: "cannot build an initial slot snapshot as oldest safe xid %u follows snapshot's xmin %u"
slug: cannot-build-an-initial-slot-snapshot-as-oldest-safe-xid-follows-snapshot-s-xmin
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/snapbuild.c:487"
reproduced: false
---

# `cannot build an initial slot snapshot as oldest safe xid %u follows snapshot's xmin %u`

## What it means

Logical decoding could not build an initial snapshot for a replication slot because the oldest transaction ID considered safe has already advanced past the snapshot's lower bound. The snapshot would miss transactions it needs, so the build is refused. The placeholders are the two transaction IDs.

## When it happens

It occurs during logical-slot creation or export, when catalog cleanup has progressed far enough that a consistent starting snapshot can no longer be assembled.

## How to fix

Retry the slot snapshot; the decoder normally reaches a consistent point again on a later attempt. Avoid aggressive vacuuming of catalogs while a slot is being initialized, and ensure the slot is created before long-running catalog activity.

## Example

*Illustrative* — the safe-xid guard during slot creation.

```text
ERROR:  cannot build an initial slot snapshot as oldest safe xid 1234 follows snapshot's xmin 1200
```

## Related

- [cannot build an initial slot snapshot before reaching a consistent state](./cannot-build-an-initial-slot-snapshot-before-reaching-a-consistent-state.md)
- [cannot build an initial slot snapshot when snapshots exist](./cannot-build-an-initial-slot-snapshot-when-snapshots-exist.md)
