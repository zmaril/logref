---
message: "cannot perform DELETE RETURNING on relation \"%s\""
slug: cannot-perform-delete-returning-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:4558"
reproduced: false
---

# `cannot perform DELETE RETURNING on relation "%s"`

## What it means

A `DELETE ... RETURNING` targeted a relation that cannot return the deleted rows. The relation — often a view without the needed support — has no way to report what was removed. The placeholder is the relation name.

## When it happens

It occurs when a `DELETE ... RETURNING` runs against a view or foreign table whose rewrite rules or wrapper do not support returning rows.

## How to fix

Add an `INSTEAD OF DELETE` trigger to the view that supports `RETURNING`, run the `DELETE` on the base table, or drop the `RETURNING` clause if you do not need the removed rows.

## Example

*Illustrative* — DELETE RETURNING on an unsupported relation.

```text
ERROR:  cannot perform DELETE RETURNING on relation "v_orders"
```

## Related

- [cannot perform INSERT RETURNING on relation](./cannot-perform-insert-returning-on-relation.md)
- [cannot perform UPDATE RETURNING on relation](./cannot-perform-update-returning-on-relation.md)
