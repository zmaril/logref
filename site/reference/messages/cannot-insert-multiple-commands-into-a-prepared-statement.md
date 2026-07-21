---
message: "cannot insert multiple commands into a prepared statement"
slug: cannot-insert-multiple-commands-into-a-prepared-statement
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/tcop/postgres.c:1510"
reproduced: false
---

# `cannot insert multiple commands into a prepared statement`

## What it means

A `PREPARE` or a protocol-level prepared statement was given a string containing more than one SQL command. A prepared statement holds a single command, so a multi-statement string is rejected.

## When it happens

It occurs when the prepared-statement text contains several semicolon-separated commands, for example passing a script to `PQprepare` or the `PREPARE` statement.

## How to fix

Prepare one command per statement. Split a multi-statement string into separate prepares, or run the batch through a simple-query path that accepts multiple commands.

## Example

*Illustrative* — two commands in one prepared statement.

```text
ERROR:  cannot insert multiple commands into a prepared statement
```

## Related

- [cannot have more than 2^32-2 commands in a transaction](./cannot-have-more-than-2-32-2-commands-in-a-transaction.md)
- [cannot insert into foreign table](./cannot-insert-into-foreign-table.md)
