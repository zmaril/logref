---
message: "cannot add column to typed table"
slug: cannot-add-column-to-typed-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:7339"
reproduced: true
---

# `cannot add column to typed table`

## What it means

An `ALTER TABLE ... ADD COLUMN` was issued against a typed table — one created with `OF type`. A typed table's columns come from its composite type, so columns cannot be added to the table directly.

## When it happens

It occurs when running `ALTER TABLE ADD COLUMN` on a table defined with `CREATE TABLE ... OF sometype`.

## How to fix

Add the attribute to the underlying composite type with `ALTER TYPE sometype ADD ATTRIBUTE ...`, which extends every typed table built on it. The table's columns follow its type, not standalone alterations.

## Example

*Reproduced* — captured from `reproducers/scenarios/35_ddl_object_lifecycle.sql`.

```sql
ALTER TABLE s35.typedtab ADD COLUMN q int;
```

Produces:

```text
ERROR:  cannot add column to typed table
```

## Related

- [cannot add column to a partition](./cannot-add-column-to-a-partition.md)
- [cannot alter column type of typed table](./cannot-alter-column-type-of-typed-table.md)
