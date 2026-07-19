---
message: "cannot alter type \"%s\" because column \"%s.%s\" uses it"
slug: cannot-alter-type-because-column-uses-it
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:7180"
  - "postgres/src/backend/commands/tablecmds.c:7187"
reproduced: false
---

# `cannot alter type "%s" because column "%s.%s" uses it`

## What it means

An `ALTER TYPE` was rejected because a table column still uses the type being changed. The placeholders are the type name and the qualified column. Altering the type in a way that would invalidate stored column values is not permitted while the column depends on it.

## When it happens

`ALTER TYPE ... ADD/RENAME/ALTER ATTRIBUTE` or a similar structural change on a composite or enum type that one or more table columns are declared with.

## How to fix

Drop or alter the dependent column first, or make the type change in a way that does not affect on-disk representation. For composite types, you may need to change columns of that type together with the type. Query `pg_depend` or the error's column reference to find every dependent column before retrying.

## Example

*Illustrative* — altering a composite type a column uses.

```sql
ALTER TYPE addr ADD ATTRIBUTE zip text;
-- ERROR:  cannot alter type "addr" because column "people.home" uses it
```

## Related

- [cached plan must not change result type](./cached-plan-must-not-change-result-type.md)
- [column is of type but default expression is of type](./column-is-of-type-but-default-expression-is-of-type.md)
