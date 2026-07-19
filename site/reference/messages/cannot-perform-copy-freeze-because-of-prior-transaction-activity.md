---
message: "cannot perform COPY FREEZE because of prior transaction activity"
slug: cannot-perform-copy-freeze-because-of-prior-transaction-activity
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_STATE
    code: "25000"
call_sites:
  - "postgres/src/backend/commands/copyfrom.c:900"
reproduced: false
---

# `cannot perform COPY FREEZE because of prior transaction activity`

## What it means

A `COPY ... WITH (FREEZE)` was rejected because the table already saw activity earlier in the transaction. `FREEZE` marks the loaded rows as immediately visible to all transactions, which is only safe when the transaction itself created or truncated the table with nothing else having touched it.

## When it happens

It occurs when the table was created or truncated in the transaction, but the transaction then performed other work on it before the `COPY FREEZE`.

## How to fix

Run the `COPY FREEZE` immediately after creating or truncating the table, with no intervening activity on that table in the same transaction. Restructure the load so the freeze is the first operation on the fresh table.

## Example

*Illustrative* — COPY FREEZE after prior activity.

```text
ERROR:  cannot perform COPY FREEZE because of prior transaction activity
```

## Related

- [cannot perform COPY FREEZE because the table was not created or truncated in the current subtransaction](./cannot-perform-copy-freeze-because-the-table-was-not-created-or-truncated-in.md)
- [cannot perform COPY FREEZE on a partitioned table](./cannot-perform-copy-freeze-on-a-partitioned-table.md)
