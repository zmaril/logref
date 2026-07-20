---
message: "cannot change owner of relation \"%s\""
slug: cannot-change-owner-of-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:16873"
reproduced: false
---

# `cannot change owner of relation "%s"`

## What it means

An `ALTER TABLE ... OWNER TO` or similar command targeted a relation whose owner cannot be changed directly — typically an index or a TOAST table whose ownership follows its parent. The placeholder is the relation name.

## When it happens

It occurs when trying to change the owner of an index or other dependent relation that inherits its owner from another object.

## How to fix

Change the owner of the parent table instead; dependent objects such as indexes and TOAST tables follow it. Ownership of these relations is not set independently.

## Example

*Illustrative* — changing an index's owner.

```text
ERROR:  cannot change owner of relation "t_pkey"
```

## Related

- [cannot change owner of sequence](./cannot-change-owner-of-sequence.md)
- [cannot change ownership of identity sequence](./cannot-change-ownership-of-identity-sequence.md)
