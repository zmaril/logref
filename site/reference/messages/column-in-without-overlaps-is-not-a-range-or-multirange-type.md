---
message: "column \"%s\" in WITHOUT OVERLAPS is not a range or multirange type"
slug: column-in-without-overlaps-is-not-a-range-or-multirange-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:2807"
reproduced: false
---

# `column "%s" in WITHOUT OVERLAPS is not a range or multirange type`

## What it means

A `WITHOUT OVERLAPS` clause in a primary-key or unique constraint named a column whose type is not a range or multirange. The overlap check compares periods, so the trailing column must hold a range or multirange value.

## When it happens

It happens on `CREATE TABLE` or `ALTER TABLE ... ADD CONSTRAINT` with a temporal `PRIMARY KEY`/`UNIQUE ... WITHOUT OVERLAPS` when the overlap column is an ordinary scalar type.

## How to fix

Use a range or multirange type for the `WITHOUT OVERLAPS` column (for example `tstzrange` or `int4range`), or convert the existing period columns into a single range column before defining the constraint.

## Example

*Illustrative* — a scalar column used with WITHOUT OVERLAPS.

```sql
CREATE TABLE t (id int, valid_at timestamptz,
  PRIMARY KEY (id, valid_at WITHOUT OVERLAPS));
-- ERROR:  column "valid_at" in WITHOUT OVERLAPS is not a range or multirange type
```

## Related

- [constraint using WITHOUT OVERLAPS needs at least two columns](./constraint-using-without-overlaps-needs-at-least-two-columns.md)
- [column of relation is not a range or multirange type](./column-of-relation-is-not-a-range-or-multirange-type.md)
