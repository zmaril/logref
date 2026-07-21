---
message: "insert or update on table \"%s\" violates foreign key constraint \"%s\""
slug: insert-or-update-on-table-violates-foreign-key-constraint
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FOREIGN_KEY_VIOLATION
    code: "23503"
call_sites:
  - "postgres/src/backend/utils/adt/ri_triggers.c:419"
  - "postgres/src/backend/utils/adt/ri_triggers.c:1927"
  - "postgres/src/backend/utils/adt/ri_triggers.c:3711"
reproduced: false
---

# `insert or update on table "%s" violates foreign key constraint "%s"`

## What it means

A row inserted or updated in the referencing table holds a foreign-key value that has no matching row in the referenced table. The constraint requires every non-null key to point at an existing parent row, and this one does not.

## When it happens

Inserting a child row before its parent exists, updating a child's key to a value the parent table does not contain, or loading data in an order that puts children ahead of parents. It also fires when the referenced parent row was never committed by the transaction that appeared to create it.

## How to fix

Ensure the referenced row exists before you write the referencing row. Insert or commit parents first, load tables in dependency order, or correct the key value to one that exists in the parent. If the reference is genuinely optional, make the column nullable and store `NULL` rather than a non-matching value. For bulk loads, deferring the constraint (`SET CONSTRAINTS ... DEFERRED`) lets you insert both sides within one transaction.

## Example

*Illustrative* — a child row with no matching parent.

```sql
INSERT INTO orders (customer_id) VALUES (999);  -- no customer 999 exists
```

## Related

- [violates foreign key constraint](./insert-or-update-on-table-violates-foreign-key-constraint.md)
- [column referenced in foreign key constraint does not exist](./column-referenced-in-foreign-key-constraint-does-not-exist.md)
