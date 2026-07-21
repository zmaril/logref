---
message: "invalid null namespace in object %u/%u/%d"
slug: invalid-null-namespace-in-object
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:4543"
  - "postgres/src/backend/commands/event_trigger.c:2172"
reproduced: false
---

# `invalid null namespace in object %u/%u/%d`

## What it means

Internal error. Undo/relation-identity code found an object identified by database, tablespace, and relation numbers where a required namespace component is null/zero when it must be set. The placeholders are the numeric object identity. It is a consistency guard.

## When it happens

It fires from internal storage bookkeeping when a relation identifier is incomplete. Ordinary queries do not surface it; it points to an internal inconsistency.

## How to fix

This is a can't-happen guard. Capture the operation and, if it correlates with a specific relation, that relation's identity, and report a reproducible case. Investigate storage if it appears alongside other corruption.

## Example

*Illustrative* — an object identity missing its namespace.

```text
ERROR:  invalid null namespace in object 1663/16384/0
```

## Related

- [no relation entry for relid](./no-relation-entry-for-relid.md)
- [invalid attnum](./invalid-attnum.md)
