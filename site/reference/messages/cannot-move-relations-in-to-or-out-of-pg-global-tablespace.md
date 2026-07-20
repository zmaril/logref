---
message: "cannot move relations in to or out of pg_global tablespace"
slug: cannot-move-relations-in-to-or-out-of-pg-global-tablespace
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:17718"
reproduced: false
---

# `cannot move relations in to or out of pg_global tablespace`

## What it means

An operation tried to move a relation into or out of the `pg_global` tablespace. `pg_global` is reserved for shared system catalogs, whose placement is fixed, so relations cannot be moved across its boundary.

## When it happens

It occurs when an `ALTER TABLE`/`ALTER INDEX ... SET TABLESPACE`, or a tablespace-wide move, names `pg_global` as source or destination.

## How to fix

Keep user relations in regular tablespaces and leave shared catalogs in `pg_global`. Do not target `pg_global` when moving relations between tablespaces.

## Example

*Illustrative* — moving a relation across the pg_global boundary.

```text
ERROR:  cannot move relations in to or out of pg_global tablespace
```

## Related

- [cannot move non-shared relation to tablespace](./cannot-move-non-shared-relation-to-tablespace.md)
- [cannot have multiple SET TABLESPACE subcommands](./cannot-have-multiple-set-tablespace-subcommands.md)
