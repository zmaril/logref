---
message: "cannot move non-shared relation to tablespace \"%s\""
slug: cannot-move-non-shared-relation-to-tablespace
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:4014"
reproduced: false
---

# `cannot move non-shared relation to tablespace "%s"`

## What it means

An operation tried to move an ordinary (non-shared) relation into a tablespace reserved for shared objects. The `pg_global` tablespace holds only shared system catalogs, so a regular relation may not be placed there. The placeholder is the tablespace name.

## When it happens

It occurs when an `ALTER TABLE`/`ALTER INDEX ... SET TABLESPACE` or index build targets `pg_global` for a normal user or per-database relation.

## How to fix

Move the relation into a regular tablespace (such as `pg_default` or a user-created one). Reserve `pg_global` for the shared system catalogs that belong there.

## Example

*Illustrative* — moving a regular relation to pg_global.

```text
ERROR:  cannot move non-shared relation to tablespace "pg_global"
```

## Related

- [cannot move relations in to or out of pg_global tablespace](./cannot-move-relations-in-to-or-out-of-pg-global-tablespace.md)
- [cannot have multiple SET TABLESPACE subcommands](./cannot-have-multiple-set-tablespace-subcommands.md)
