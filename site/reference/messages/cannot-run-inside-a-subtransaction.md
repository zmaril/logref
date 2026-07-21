---
message: "%s cannot run inside a subtransaction"
slug: cannot-run-inside-a-subtransaction
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ACTIVE_SQL_TRANSACTION
    code: "25001"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:3717"
reproduced: false
---

# `%s cannot run inside a subtransaction`

## What it means

A command that must run at the top transaction level was issued inside a subtransaction. The named command cannot run within a savepoint or exception block. The placeholder is the command name.

## When it happens

It occurs when a command such as `VACUUM`, `CREATE INDEX CONCURRENTLY`, or another non-transactional command is invoked inside a PL/pgSQL exception block or after a `SAVEPOINT`.

## How to fix

Run the command at the top level of its own transaction, outside any savepoint or exception-handling block. Move it out of the block, or run it as a standalone statement.

## Example

*Illustrative* — a top-level command inside a subtransaction.

```text
ERROR:  VACUUM cannot run inside a subtransaction
```

## Related

- [cannot run inside a transaction block](./cannot-run-inside-a-transaction-block.md)
- [cannot roll back while a subtransaction is active](./cannot-roll-back-while-a-subtransaction-is-active.md)
