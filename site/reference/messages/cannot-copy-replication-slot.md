---
message: "cannot copy replication slot \"%s\""
slug: cannot-copy-replication-slot
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/slotfuncs.c:829"
reproduced: false
---

# `cannot copy replication slot "%s"`

## What it means

A slot-copy operation could not proceed for the named slot because the source and destination slot kinds do not match, or the source is otherwise not copyable in the requested way. The placeholder is the slot name.

## When it happens

It occurs when copying a slot with a mismatch between the source kind and the copy function used, or when the source is not in a copyable state.

## How to fix

Use the copy function that matches the slot kind — logical for logical, physical for physical — and confirm the source slot is active and reserving WAL. Address any mismatch before retrying.

## Example

*Illustrative* — a mismatched slot copy.

```text
ERROR:  cannot copy replication slot "s"
```

## Related

- [cannot copy physical replication slot as a logical replication slot](./cannot-copy-physical-replication-slot-as-a-logical-replication-slot.md)
- [cannot copy invalidated replication slot](./cannot-copy-invalidated-replication-slot.md)
