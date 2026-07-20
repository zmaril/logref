---
message: "cannot rename columns of relation \"%s\""
slug: cannot-rename-columns-of-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:3898"
reproduced: false
---

# `cannot rename columns of relation "%s"`

## What it means

An `ALTER TABLE ... RENAME COLUMN` targeted a relation whose kind does not allow column renames. The relation is of a type that has no user-renamable columns. The placeholder is the relation name.

## When it happens

It occurs when a rename-column command is run against an object such as a composite-type-backed or otherwise unsupported relation.

## How to fix

Rename columns only on relations that support it (ordinary tables, and views through their definitions). For type-backed objects, change the underlying type instead.

## Example

*Illustrative* — renaming columns on an unsupported relation.

```text
ERROR:  cannot rename columns of relation "my_obj"
```

## Related

- [cannot rename columns of conflict log table](./cannot-rename-columns-of-conflict-log-table.md)
- [cannot rename column of typed table](./cannot-rename-column-of-typed-table.md)
