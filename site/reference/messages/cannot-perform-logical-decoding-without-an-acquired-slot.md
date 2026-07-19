---
message: "cannot perform logical decoding without an acquired slot"
slug: cannot-perform-logical-decoding-without-an-acquired-slot
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/logical.c:349"
  - "postgres/src/backend/replication/logical/logical.c:508"
reproduced: false
---

# `cannot perform logical decoding without an acquired slot`

## What it means

A logical-decoding operation was started without first acquiring a logical replication slot. Logical decoding is anchored to a slot that tracks its position; without one, there is no context to decode against.

## When it happens

Calling logical-decoding functions or starting decoding on a connection that has not acquired a logical slot, or where the slot acquisition failed earlier in the session.

## How to fix

Create and acquire a logical replication slot before decoding — for example via `pg_create_logical_replication_slot()` and then `pg_logical_slot_get_changes()`, or a `START_REPLICATION` on a named logical slot. Ensure the slot exists and is not held by another session.

## Example

*Illustrative* — decoding without a slot.

```text
ERROR:  cannot perform logical decoding without an acquired slot
```

## Related

- [cannot use physical replication slot for logical decoding](./cannot-use-physical-replication-slot-for-logical-decoding.md)
- [cannot enable failover for a temporary replication slot](./cannot-enable-failover-for-a-temporary-replication-slot.md)
