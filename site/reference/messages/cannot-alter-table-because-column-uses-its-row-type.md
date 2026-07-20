---
message: "cannot alter table \"%s\" because column \"%s.%s\" uses its row type"
slug: cannot-alter-table-because-column-uses-its-row-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:7201"
reproduced: false
---

# `cannot alter table "%s" because column "%s.%s" uses its row type`

## What it means

An `ALTER TABLE` change was blocked because a column somewhere is declared with the table's row type. The placeholders name the table and the dependent column. Altering the table would change a composite type another column depends on.

## When it happens

It occurs when altering a table whose row type is used as the declared type of a column in another table or object.

## How to fix

Break the dependency first: alter or drop the column that uses the table's row type, apply the change, then restore the dependent column. A table's row type cannot be altered while a column is declared with it.

## Example

*Illustrative* — a table whose row type is in use.

```text
ERROR:  cannot alter table "t" because column "other.c" uses its row type
```

## Related

- [cannot alter foreign table because column uses its row type](./cannot-alter-foreign-table-because-column-uses-its-row-type.md)
- [cannot alter type because it is the type of a typed table](./cannot-alter-type-because-it-is-the-type-of-a-typed-table.md)
