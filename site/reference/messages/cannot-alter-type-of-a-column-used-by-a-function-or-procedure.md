---
message: "cannot alter type of a column used by a function or procedure"
slug: cannot-alter-type-of-a-column-used-by-a-function-or-procedure
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:15664"
reproduced: false
---

# `cannot alter type of a column used by a function or procedure`

## What it means

An `ALTER TABLE ... ALTER COLUMN ... TYPE` was blocked because a function or procedure depends on the column's current type — for example through a parameter or return type tied to the table's row type. Changing the column would break that routine's signature.

## When it happens

It occurs when altering a column type on a table whose row type, or the column itself, is referenced by a function's or procedure's declared types.

## How to fix

Remove or adjust the dependency first: drop or redefine the function or procedure that depends on the type, alter the column, then recreate the routine against the new type. The column type cannot change while a routine's signature depends on it.

## Example

*Illustrative* — a column type used by a routine.

```text
ERROR:  cannot alter type of a column used by a function or procedure
```

## Related

- [cannot alter type because it is the type of a typed table](./cannot-alter-type-because-it-is-the-type-of-a-typed-table.md)
- [cannot alter table because column uses its row type](./cannot-alter-table-because-column-uses-its-row-type.md)
