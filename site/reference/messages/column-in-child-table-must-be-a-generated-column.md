---
message: "column \"%s\" in child table must be a generated column"
slug: column-in-child-table-must-be-a-generated-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:18269"
reproduced: false
---

# `column "%s" in child table must be a generated column`

## What it means

A child (inheriting or partition) table has a plain column where its parent defines that column as generated. An inherited generated column must remain generated in every child, so the mismatch is rejected.

## When it happens

It happens on `CREATE TABLE ... INHERITS`, `ATTACH PARTITION`, or `ALTER TABLE` when the parent's column is a generated column but the child declares the same column as an ordinary one.

## How to fix

Declare the child column as generated, using the same generation expression as the parent, or drop the plain column so it is inherited from the parent unchanged.

## Example

*Illustrative* — a child overriding a generated column with a plain one.

```sql
CREATE TABLE p (a int, b int GENERATED ALWAYS AS (a * 2) STORED);
CREATE TABLE c (a int, b int) INHERITS (p);
-- ERROR:  column "b" in child table must be a generated column
```

## Related

- [column in child table must not be a generated column](./column-in-child-table-must-not-be-a-generated-column.md)
- [column inherits conflicting generation expressions](./column-inherits-conflicting-generation-expressions.md)
