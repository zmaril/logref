---
message: "%s cannot be executed from a function or procedure"
slug: cannot-be-executed-from-a-function-or-procedure
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ACTIVE_SQL_TRANSACTION
    code: "25001"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:3727"
reproduced: false
---

# `%s cannot be executed from a function or procedure`

## What it means

A statement that must run at the top level of a session — such as `VACUUM`, `CREATE DATABASE`, or another command that cannot run inside a transaction block — was invoked from within a function or procedure. Those routines run inside a transaction, where such statements are not allowed.

## When it happens

It occurs when PL/pgSQL or another function body issues a command that requires its own transaction context, for example `VACUUM` inside a function.

## How to fix

Run the statement directly at the session level, not from inside a function. In a procedure you may be able to use transaction control, but commands that forbid a transaction block must run standalone.

## Example

*Illustrative* — VACUUM inside a function.

```text
ERROR:  VACUUM cannot be executed from a function or procedure
```

## Related

- [cannot be executed from vacuum or analyze](./cannot-be-executed-from-vacuum-or-analyze.md)
- [cannot be applied to a with query](./cannot-be-applied-to-a-with-query.md)
