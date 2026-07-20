---
message: "cannot PREPARE a transaction that has operated on postgres_fdw foreign tables"
slug: cannot-prepare-a-transaction-that-has-operated-on-postgres-fdw-foreign-tables
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/postgres_fdw/connection.c:1260"
reproduced: false
---

# `cannot PREPARE a transaction that has operated on postgres_fdw foreign tables`

## What it means

A `PREPARE TRANSACTION` was rejected because the transaction touched `postgres_fdw` foreign tables. The wrapper cannot include the remote work in the local two-phase commit, so the prepare is refused.

## When it happens

It occurs when a transaction reads or writes `postgres_fdw` foreign tables and then issues `PREPARE TRANSACTION`.

## How to fix

Commit transactions that use `postgres_fdw` foreign tables normally rather than preparing them, or isolate the foreign-table work into its own transaction. Distributed two-phase commit across the wrapper is not supported here.

## Example

*Illustrative* — PREPARE after using a foreign table.

```text
ERROR:  cannot PREPARE a transaction that has operated on postgres_fdw foreign tables
```

## Related

- [cannot PREPARE a transaction that modified relation mapping](./cannot-prepare-a-transaction-that-modified-relation-mapping.md)
- [cannot route tuples into foreign table to be updated](./cannot-route-tuples-into-foreign-table-to-be-updated.md)
