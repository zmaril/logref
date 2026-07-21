---
message: "database \"%s\" must be vacuumed within %u transactions"
slug: database-must-be-vacuumed-within-transactions
passthrough: false
api: [ereport]
level: [WARNING]
call_sites:
  - "postgres/src/backend/access/transam/varsup.c:165"
  - "postgres/src/backend/access/transam/varsup.c:484"
reproduced: false
---

# `database "%s" must be vacuumed within %u transactions`

## What it means

A wraparound warning that a database is approaching the transaction-ID (XID) limit and must be vacuumed within a stated number of further transactions.

## When it happens

It arises when the oldest unfrozen XID in the database advances toward the wraparound threshold and freezing has not kept pace.

## Is this a problem?

Vacuum the named database to freeze old transaction IDs. Confirm autovacuum is running and not being blocked (long-running transactions, prepared transactions, or stale replication slots hold back the horizon); ignoring this leads to a forced shutdown.

## Example

*Illustrative* — approaching the XID limit.

```text
WARNING:  database "app" must be vacuumed within 10000000 transactions
```

## Related

- [database "%s" must be vacuumed before %u more MultiXactId is used](./database-must-be-vacuumed-before-more-multixactid-is-used.md)
- [database with OID %u must be vacuumed within %u transactions](./database-with-oid-must-be-vacuumed-within-transactions.md)
