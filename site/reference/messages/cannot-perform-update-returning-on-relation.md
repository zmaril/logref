---
message: "cannot perform UPDATE RETURNING on relation \"%s\""
slug: cannot-perform-update-returning-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:4551"
reproduced: false
---

# `cannot perform UPDATE RETURNING on relation "%s"`

## What it means

An `UPDATE ... RETURNING` targeted a relation that cannot return the updated rows. The relation has no way to report the modified rows. The placeholder is the relation name.

## When it happens

It occurs when an `UPDATE ... RETURNING` runs against a view or foreign table whose rules or wrapper do not support returning rows.

## How to fix

Add an `INSTEAD OF UPDATE` trigger that supports `RETURNING`, update the base table, or drop the `RETURNING` clause if the returned rows are not needed.

## Example

*Illustrative* — UPDATE RETURNING on an unsupported relation.

```text
ERROR:  cannot perform UPDATE RETURNING on relation "v_orders"
```

## Related

- [cannot perform DELETE RETURNING on relation](./cannot-perform-delete-returning-on-relation.md)
- [cannot perform INSERT RETURNING on relation](./cannot-perform-insert-returning-on-relation.md)
