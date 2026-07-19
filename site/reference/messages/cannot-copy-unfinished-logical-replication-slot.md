---
message: "cannot copy unfinished logical replication slot \"%s\""
slug: cannot-copy-unfinished-logical-replication-slot
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/replication/slotfuncs.c:814"
reproduced: false
---

# `cannot copy unfinished logical replication slot "%s"`

## What it means

A call to `pg_copy_logical_replication_slot` named a source slot whose initial setup is not complete. A logical slot must have finished its consistent-point handshake before it can be copied. The placeholder is the slot name.

## When it happens

It occurs when copying a logical slot that is still initializing and has not yet reached a usable state.

## How to fix

Wait for the source slot to finish initializing before copying it, or create a fresh slot. A logical slot is copyable only once it is fully established.

## Example

*Illustrative* — copying an unfinished slot.

```text
ERROR:  cannot copy unfinished logical replication slot "s"
```

## Related

- [cannot copy physical replication slot as a logical replication slot](./cannot-copy-physical-replication-slot-as-a-logical-replication-slot.md)
- [cannot copy invalidated replication slot](./cannot-copy-invalidated-replication-slot.md)
