---
message: "cannot lock relation \"%s\""
slug: cannot-lock-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/lockcmds.c:101"
reproduced: false
---

# `cannot lock relation "%s"`

## What it means

A `LOCK TABLE` command targeted an object that cannot be locked as a table. The named relation is of a kind that does not accept table-level locks, such as a view or another non-lockable object. The placeholder is the relation name.

## When it happens

It occurs when `LOCK TABLE` names a view, a composite type, or another object that is not a lockable relation.

## How to fix

Lock an ordinary table, materialized view, or another lockable relation. If you need to serialize access through a view, lock the underlying base tables instead.

## Example

*Illustrative* — locking an unlockable object.

```text
ERROR:  cannot lock relation "my_view"
```

## Related

- [cannot lock rows in relation](./cannot-lock-rows-in-relation.md)
- [cannot lock rows in view](./cannot-lock-rows-in-view.md)
