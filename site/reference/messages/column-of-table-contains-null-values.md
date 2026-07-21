---
message: "column \"%s\" of table \"%s\" contains null values"
slug: column-of-table-contains-null-values
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NOT_NULL_VIOLATION
    code: "23502"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:3212"
reproduced: true
---

# `column "%s" of table "%s" contains null values`

## What it means

A domain or constraint being applied to a table requires the column to have no nulls, but existing rows contain null values in that column. The constraint cannot be validated against the current data.

## When it happens

It happens when altering a domain to `NOT NULL` (or a similar operation) that is used as a column's type, when stored rows have nulls there.

## How to fix

Update or remove the offending rows so the column has no nulls, then reapply the constraint. Find them with `SELECT ... WHERE col IS NULL`.

## Example

*Reproduced* — captured from `reproducers/scenarios/37_alter_type_column_tablespace.sql`.

```sql
ALTER DOMAIN s37.posint SET NOT NULL;
```

Produces:

```text
ERROR:  column "v" of table "usedom" contains null values
```

## Related

- [column of table contains values that violate the new constraint](./column-of-table-contains-values-that-violate-the-new-constraint.md)
- [column of table is not marked NOT NULL](./column-of-table-is-not-marked-not-null.md)
