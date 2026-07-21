---
message: "cannot perform INSERT RETURNING on relation \"%s\""
slug: cannot-perform-insert-returning-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:4544"
reproduced: false
---

# `cannot perform INSERT RETURNING on relation "%s"`

## What it means

An `INSERT ... RETURNING` targeted a relation that cannot return the inserted rows. The relation has no mechanism to report the newly written rows. The placeholder is the relation name.

## When it happens

It occurs when an `INSERT ... RETURNING` runs against a view or foreign table whose rules or wrapper do not support returning rows.

## How to fix

Add an `INSTEAD OF INSERT` trigger that supports `RETURNING`, insert into the base table, or drop the `RETURNING` clause if the returned rows are not needed.

## Example

*Illustrative* — INSERT RETURNING on an unsupported relation.

```text
ERROR:  cannot perform INSERT RETURNING on relation "v_orders"
```

## Related

- [cannot perform DELETE RETURNING on relation](./cannot-perform-delete-returning-on-relation.md)
- [cannot perform UPDATE RETURNING on relation](./cannot-perform-update-returning-on-relation.md)
