---
message: "column privileges are only valid for relations"
slug: column-privileges-are-only-valid-for-relations
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_GRANT_OPERATION
    code: "0LP01"
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:565"
reproduced: false
---

# `column privileges are only valid for relations`

## What it means

A `GRANT`/`REVOKE` specified column-level privileges on an object that is not a relation (table, view, or similar). Only relations have columns, so column privileges cannot apply to other object kinds.

## When it happens

It happens when a column list is attached to a `GRANT` on an object type such as a function, schema, or database.

## How to fix

Remove the column list, or target a relation. Column-level grants only make sense with `GRANT ... ON TABLE tab (cols) ...`.

## Example

*Illustrative* — column privileges on a non-relation.

```sql
GRANT SELECT (a) ON DATABASE mydb TO alice;
-- ERROR:  column privileges are only valid for relations
```

## Related

- [column names cannot be included in GRANT/REVOKE ROLE](./column-names-cannot-be-included-in-grant-revoke-role.md)
- [column number out of range](./column-number-out-of-range.md)
