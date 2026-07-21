---
message: "cannot alter column type of typed table"
slug: cannot-alter-column-type-of-typed-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:14934"
reproduced: true
---

# `cannot alter column type of typed table`

## What it means

An `ALTER TABLE ... ALTER COLUMN ... TYPE` was issued against a typed table created with `OF type`. A typed table's column types are fixed by its composite type and cannot be changed on the table directly.

## When it happens

It occurs when trying to change a column's type on a table defined with `CREATE TABLE ... OF sometype`.

## How to fix

Change the attribute's type on the underlying composite type with `ALTER TYPE sometype ALTER ATTRIBUTE ... TYPE ...`, which updates every typed table built on it. The table's column types follow its type.

## Example

*Reproduced* — captured from `reproducers/scenarios/37_alter_type_column_tablespace.sql`.

```sql
ALTER TABLE s37.typed ALTER COLUMN a TYPE bigint;
```

Produces:

```text
ERROR:  cannot alter column type of typed table
```

## Related

- [cannot add column to typed table](./cannot-add-column-to-typed-table.md)
- [cannot alter type because it is the type of a typed table](./cannot-alter-type-because-it-is-the-type-of-a-typed-table.md)
