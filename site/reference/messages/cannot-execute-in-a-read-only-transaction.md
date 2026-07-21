---
message: "cannot execute %s in a read-only transaction"
slug: cannot-execute-in-a-read-only-transaction
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_READ_ONLY_SQL_TRANSACTION
    code: "25006"
call_sites:
  - "postgres/src/backend/tcop/utility.c:412"
reproduced: true
---

# `cannot execute %s in a read-only transaction`

## What it means

A command that writes data or changes state was issued inside a read-only transaction. The transaction was set read-only, so the named command is rejected. The placeholder is the command name.

## When it happens

It occurs when the session ran `SET TRANSACTION READ ONLY` or `SET default_transaction_read_only = on`, or when the server is a hot standby, and then a write or DDL command is attempted.

## How to fix

Start a read-write transaction for the command: use `SET TRANSACTION READ WRITE`, or clear `default_transaction_read_only`. On a standby, run the write on the primary instead.

## Example

*Reproduced* — captured from `reproducers/scenarios/24_txn_copy_cursor.sql`.

```sql
INSERT INTO repro.parent VALUES (99,'x');
```

Produces:

```text
ERROR:  cannot execute INSERT in a read-only transaction
```

## Related

- [cannot execute during recovery](./cannot-execute-during-recovery.md)
- [cannot execute within security-restricted operation](./cannot-execute-within-security-restricted-operation.md)
