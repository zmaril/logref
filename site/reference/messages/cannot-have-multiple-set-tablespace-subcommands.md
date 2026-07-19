---
message: "cannot have multiple SET TABLESPACE subcommands"
slug: cannot-have-multiple-set-tablespace-subcommands
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:17340"
reproduced: false
---

# `cannot have multiple SET TABLESPACE subcommands`

## What it means

A single `ALTER TABLE` statement contained more than one `SET TABLESPACE` subcommand. A table lives in one tablespace, so the statement may set it only once.

## When it happens

It occurs when an `ALTER TABLE` combines several `SET TABLESPACE` clauses in one statement.

## How to fix

Specify `SET TABLESPACE` only once per `ALTER TABLE`. Name the single destination tablespace in one subcommand.

## Example

*Illustrative* — two SET TABLESPACE clauses.

```text
ERROR:  cannot have multiple SET TABLESPACE subcommands
```

## Related

- [cannot have multiple SET ACCESS METHOD subcommands](./cannot-have-multiple-set-access-method-subcommands.md)
- [cannot move non-shared relation to tablespace](./cannot-move-non-shared-relation-to-tablespace.md)
