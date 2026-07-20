---
message: "cannot alter type \"%s\" because it is the type of a typed table"
slug: cannot-alter-type-because-it-is-the-type-of-a-typed-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DEPENDENT_OBJECTS_STILL_EXIST
    code: "2BP01"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:7257"
reproduced: false
---

# `cannot alter type "%s" because it is the type of a typed table`

## What it means

An `ALTER TYPE` change was blocked because the type is used as the row type of a typed table. The placeholder is the type. A typed table's structure comes from this type, so certain alterations are restricted while such a table exists.

## When it happens

It occurs when altering a composite type that one or more `CREATE TABLE ... OF thistype` tables depend on.

## How to fix

Use `ALTER TYPE ... ADD/DROP/ALTER ATTRIBUTE ... CASCADE` to propagate the change to the typed tables, or drop the dependent typed tables first, alter the type, and recreate them. The type cannot be freely altered while typed tables rely on it.

## Example

*Illustrative* — altering a type backing a typed table.

```text
ERROR:  cannot alter type "t" because it is the type of a typed table
```

## Related

- [cannot alter column type of typed table](./cannot-alter-column-type-of-typed-table.md)
- [cannot alter type of a column used by a function or procedure](./cannot-alter-type-of-a-column-used-by-a-function-or-procedure.md)
