---
message: "child table \"%s\" has different type for column \"%s\""
slug: child-table-has-different-type-for-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:7418"
  - "postgres/src/backend/commands/tablecmds.c:18234"
reproduced: true
---

# `child table "%s" has different type for column "%s"`

## What it means

During inheritance or partition setup, a child table's column has a different data type than the parent's matching column. The placeholders are the child table and the column. Inherited columns must have the same type across the hierarchy.

## When it happens

Creating a child table (via `INHERITS` or `ATTACH PARTITION`) whose column type does not match the parent's column of the same name.

## How to fix

Define the child column with exactly the parent's type, then create or attach it. If the types must differ, they cannot share an inheritance relationship; reconsider the schema so inherited columns align.

## Example

*Reproduced* — captured from `reproducers/scenarios/36_constraints_partitioning.sql`.

```sql
ALTER TABLE s36.cdiff INHERIT s36.parent1;
```

Produces:

```text
ERROR:  child table "cdiff" has different type for column "a"
```

## Related

- [child table has different collation for column](./child-table-has-different-collation-for-column.md)
- [column in child table must be marked NOT NULL](./column-in-child-table-must-be-marked-not-null.md)
