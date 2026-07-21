---
message: "cannot PREPARE a transaction that modified relation mapping"
slug: cannot-prepare-a-transaction-that-modified-relation-mapping
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/cache/relmapper.c:595"
reproduced: false
---

# `cannot PREPARE a transaction that modified relation mapping`

## What it means

A `PREPARE TRANSACTION` was rejected because the transaction changed the relation mapping — the low-level file-node assignments for mapped catalogs. That mapping change cannot be safely carried through two-phase commit.

## When it happens

It occurs when a transaction runs an operation that rewrites a mapped catalog (for example certain `VACUUM FULL`/`CLUSTER`/`REINDEX` on system catalogs) and then issues `PREPARE TRANSACTION`.

## How to fix

Commit such maintenance transactions normally instead of preparing them, and keep relation-mapping changes out of two-phase-commit transactions.

## Example

*Illustrative* — PREPARE after a mapping change.

```text
ERROR:  cannot PREPARE a transaction that modified relation mapping
```

## Related

- [cannot PREPARE a transaction that has operated on temporary objects](./cannot-prepare-a-transaction-that-has-operated-on-temporary-objects.md)
- [cannot PREPARE a transaction that has operated on postgres_fdw foreign tables](./cannot-prepare-a-transaction-that-has-operated-on-postgres-fdw-foreign-tables.md)
