---
message: "column \"%s\" cannot be cast automatically to type %s"
slug: column-cannot-be-cast-automatically-to-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:15045"
reproduced: true
---

# `column "%s" cannot be cast automatically to type %s`

## What it means

An `ALTER TABLE ... ALTER COLUMN ... TYPE` asked to change a column to a new type with no automatic (implicit or assignment) cast between the old and new types. The server will not guess how to convert the data, so it stops.

## When it happens

It occurs on a type change where an automatic cast does not exist, for example converting text to an integer or between unrelated types.

## How to fix

Add a `USING` clause that gives the conversion expression, for example `ALTER TABLE t ALTER COLUMN c TYPE integer USING c::integer`. Provide the explicit transformation the type change needs.

## Example

*Reproduced* — captured from `reproducers/scenarios/27_alter_table.sql`.

```sql
ALTER TABLE repro.at ALTER COLUMN b TYPE int;
```

Produces:

```text
ERROR:  column "b" cannot be cast automatically to type integer
```

## Related

- [child table is missing column](./child-table-is-missing-column.md)
- [column data type can only have storage PLAIN](./column-data-type-can-only-have-storage-plain.md)
