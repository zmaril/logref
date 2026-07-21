---
message: "cannot truncate a table referenced in a foreign key constraint"
slug: cannot-truncate-a-table-referenced-in-a-foreign-key-constraint
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/catalog/heap.c:3763"
reproduced: true
---

# `cannot truncate a table referenced in a foreign key constraint`

## What it means

A `TRUNCATE` was issued on a table that another table references through a foreign key, without also truncating the referencing table. Truncating the referenced table would orphan the referencing rows, so it is blocked.

## When it happens

It occurs on `TRUNCATE parent` when a child table has a foreign key pointing at `parent` and the child is not included in the same command.

## How to fix

Truncate the referencing tables together in one command, or add `CASCADE` to include them automatically. If the reference should be ignored, drop or defer the foreign key first.

## Example

*Reproduced* — captured from `reproducers/scenarios/31_createtable_view_trigger.sql`.

```sql
TRUNCATE repro.parent;
```

Produces:

```text
ERROR:  cannot truncate a table referenced in a foreign key constraint
```

## Related

- [cannot truncate only a partitioned table](./cannot-truncate-only-a-partitioned-table.md)
- [cannot truncate foreign table](./cannot-truncate-foreign-table.md)
