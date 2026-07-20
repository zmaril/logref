---
message: "%s cannot run inside a transaction block"
slug: cannot-run-inside-a-transaction-block
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ACTIVE_SQL_TRANSACTION
    code: "25001"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:3707"
reproduced: false
---

# `%s cannot run inside a transaction block`

## What it means

A command that must run on its own was issued inside a transaction block. The named command cannot run within `BEGIN ... COMMIT`. The placeholder is the command name.

## When it happens

It occurs when a command such as `VACUUM`, `CREATE DATABASE`, `CREATE INDEX CONCURRENTLY`, or `ALTER SYSTEM` (in some contexts) is issued after an explicit `BEGIN`.

## How to fix

Run the command outside any transaction block, in autocommit mode as a single statement. End the current transaction first, then issue the command on its own.

## Example

*Illustrative* — a standalone command inside BEGIN.

```text
ERROR:  CREATE DATABASE cannot run inside a transaction block
```

## Related

- [cannot run inside a subtransaction](./cannot-run-inside-a-subtransaction.md)
- [cannot prevent transaction chain](./cannot-prevent-transaction-chain.md)
