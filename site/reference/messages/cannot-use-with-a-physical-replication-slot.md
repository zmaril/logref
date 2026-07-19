---
message: "cannot use %s with a physical replication slot"
slug: cannot-use-with-a-physical-replication-slot
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/replication/slot.c:957"
reproduced: false
---

# `cannot use %s with a physical replication slot`

## What it means

A replication command or option that applies only to logical decoding was used with a physical replication slot. The named operation has no meaning for a physical slot, so it is rejected.

## When it happens

It occurs on a replication protocol command or a logical decoding client when a logical-only option is combined with a physical slot.

## How to fix

Use a logical replication slot for the operation, or drop the option that does not apply to physical slots. Match the slot kind to the command.

## Example

*Illustrative* — a logical option with a physical slot.

```text
ERROR:  cannot use LOGICAL with a physical replication slot
```

## Related

- [cannot use with a logical replication slot](./cannot-use-with-a-logical-replication-slot.md)
- [cannot use replication slot for logical decoding](./cannot-use-replication-slot-for-logical-decoding.md)
