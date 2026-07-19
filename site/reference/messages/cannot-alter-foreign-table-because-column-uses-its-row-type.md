---
message: "cannot alter foreign table \"%s\" because column \"%s.%s\" uses its row type"
slug: cannot-alter-foreign-table-because-column-uses-its-row-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:7194"
reproduced: false
---

# `cannot alter foreign table "%s" because column "%s.%s" uses its row type`

## What it means

An `ALTER FOREIGN TABLE` change was blocked because a column somewhere uses the foreign table's row type. The placeholders name the foreign table and the dependent column. Altering the table would change a composite type that another column depends on.

## When it happens

It occurs when altering a foreign table whose row type is used as the type of a column in another table or object.

## How to fix

Remove or change the dependency first: alter or drop the column that uses the foreign table's row type, make the change, then restore the dependent column. A table's row type cannot be altered while another column is declared with it.

## Example

*Illustrative* — a foreign table whose row type is in use.

```text
ERROR:  cannot alter foreign table "ft" because column "other.c" uses its row type
```

## Related

- [cannot alter table because column uses its row type](./cannot-alter-table-because-column-uses-its-row-type.md)
- [cannot alter type because it is the type of a typed table](./cannot-alter-type-because-it-is-the-type-of-a-typed-table.md)
