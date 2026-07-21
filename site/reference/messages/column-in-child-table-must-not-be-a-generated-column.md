---
message: "column \"%s\" in child table must not be a generated column"
slug: column-in-child-table-must-not-be-a-generated-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:18273"
reproduced: false
---

# `column "%s" in child table must not be a generated column`

## What it means

A child table declares a column as generated where the parent defines it as an ordinary column. Whether a column is generated must match between parent and child, so a child cannot turn an inherited plain column into a generated one.

## When it happens

It occurs on `CREATE TABLE ... INHERITS`, `ATTACH PARTITION`, or `ALTER TABLE` when the child adds a generation expression to a column the parent keeps ordinary.

## How to fix

Remove the generation expression from the child column so it matches the parent, or make the parent column generated as well so both agree.

## Example

*Illustrative* — a child adding generation to a plain inherited column.

```sql
CREATE TABLE p (a int, b int);
CREATE TABLE c (a int, b int GENERATED ALWAYS AS (a) STORED) INHERITS (p);
-- ERROR:  column "b" in child table must not be a generated column
```

## Related

- [column in child table must be a generated column](./column-in-child-table-must-be-a-generated-column.md)
- [column inherits conflicting generation expressions](./column-inherits-conflicting-generation-expressions.md)
