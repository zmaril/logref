---
message: "cannot change inheritance of typed table"
slug: cannot-change-inheritance-of-typed-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:17952"
reproduced: false
---

# `cannot change inheritance of typed table`

## What it means

An `ALTER TABLE ... INHERIT` or `NO INHERIT` was applied to a typed table — one created with `OF type_name`. A typed table's structure comes from its composite type, and it cannot participate in classic inheritance, so its inheritance cannot be changed.

## When it happens

It occurs when running the inheritance commands against a table created as `CREATE TABLE ... OF some_type`.

## How to fix

Do not use inheritance with typed tables. If you need an inheritance hierarchy, use ordinary tables rather than typed tables.

## Example

*Illustrative* — inheritance change on a typed table.

```text
ERROR:  cannot change inheritance of typed table
```

## Related

- [cannot change inheritance of a partition](./cannot-change-inheritance-of-a-partition.md)
- [cannot attach a typed table as partition](./cannot-attach-a-typed-table-as-partition.md)
