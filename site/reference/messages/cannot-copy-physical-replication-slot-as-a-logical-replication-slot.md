---
message: "cannot copy physical replication slot \"%s\" as a logical replication slot"
slug: cannot-copy-physical-replication-slot-as-a-logical-replication-slot
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/replication/slotfuncs.c:698"
reproduced: false
---

# `cannot copy physical replication slot "%s" as a logical replication slot`

## What it means

A call to `pg_copy_logical_replication_slot` named a physical slot as its source. Physical and logical slots differ in kind, so a physical slot cannot be copied as a logical one. The placeholder is the slot name.

## When it happens

It occurs when the logical-slot copy function is pointed at a slot that was created as a physical replication slot.

## How to fix

Use `pg_copy_physical_replication_slot` to copy a physical slot, or `pg_copy_logical_replication_slot` only on logical slots. Match the copy function to the source slot's kind.

## Example

*Illustrative* — copying a physical slot as logical.

```text
ERROR:  cannot copy physical replication slot "s" as a logical replication slot
```

## Related

- [cannot copy unfinished logical replication slot](./cannot-copy-unfinished-logical-replication-slot.md)
- [cannot copy replication slot](./cannot-copy-replication-slot.md)
