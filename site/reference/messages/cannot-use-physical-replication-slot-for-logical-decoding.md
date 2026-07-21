---
message: "cannot use physical replication slot for logical decoding"
slug: cannot-use-physical-replication-slot-for-logical-decoding
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/logical/logical.c:356"
  - "postgres/src/backend/replication/logical/logical.c:512"
reproduced: false
---

# `cannot use physical replication slot for logical decoding`

## What it means

A logical-decoding operation named a physical replication slot. The placeholder context is a slot mismatch. Physical slots track a byte position for streaming replication; logical decoding requires a logical slot bound to an output plugin.

## When it happens

Calling `pg_logical_slot_get_changes()` or starting logical replication on a slot that was created as a physical slot rather than a logical one.

## How to fix

Create a logical slot with `pg_create_logical_replication_slot('name', 'plugin')` and use that for decoding. Physical slots cannot be repurposed for logical decoding; verify the slot type in `pg_replication_slots`.

## Example

*Illustrative* — decoding against a physical slot.

```text
ERROR:  cannot use physical replication slot for logical decoding
```

## Related

- [cannot perform logical decoding without an acquired slot](./cannot-perform-logical-decoding-without-an-acquired-slot.md)
- [cannot enable failover for a temporary replication slot](./cannot-enable-failover-for-a-temporary-replication-slot.md)
