---
message: "cannot use %s with a logical replication slot"
slug: cannot-use-with-a-logical-replication-slot
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/replication/walsender.c:551"
reproduced: false
---

# `cannot use %s with a logical replication slot`

## What it means

A replication command or option that applies only to physical replication was used with a logical replication slot. The named operation has no meaning for a logical slot, so it is rejected.

## When it happens

It occurs on a replication protocol command or a client such as `pg_receivewal` when a physical-only option is combined with a logical slot.

## How to fix

Use a physical replication slot for the operation, or drop the option that does not apply to logical slots. Match the slot kind to the command.

## Example

*Illustrative* — a physical option with a logical slot.

```text
ERROR:  cannot use TIMELINE with a logical replication slot
```

## Related

- [cannot use with a physical replication slot](./cannot-use-with-a-physical-replication-slot.md)
- [cannot use a logical replication slot for physical replication](./cannot-use-a-logical-replication-slot-for-physical-replication.md)
