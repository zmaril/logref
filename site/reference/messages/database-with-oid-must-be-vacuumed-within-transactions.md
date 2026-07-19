---
message: "database with OID %u must be vacuumed within %u transactions"
slug: database-with-oid-must-be-vacuumed-within-transactions
passthrough: false
api: [ereport]
level: [WARNING]
call_sites:
  - "postgres/src/backend/access/transam/varsup.c:174"
  - "postgres/src/backend/access/transam/varsup.c:493"
reproduced: false
---

# `database with OID %u must be vacuumed within %u transactions`

## What it means

A wraparound warning naming a database by OID that must be vacuumed within a stated number of further transactions.

## When it happens

It arises like the by-name XID warning, but from a context where only the database OID is available.

## Is this a problem?

Identify the database from its OID (`SELECT datname FROM pg_database WHERE oid = ...`) and vacuum it to freeze old transaction IDs. Check for anything holding back the XID horizon; the by-OID form carries the same urgency as the by-name one.

## Example

*Illustrative* — a by-OID XID warning.

```text
WARNING:  database with OID 16401 must be vacuumed within 10000000 transactions
```

## Related

- [database "%s" must be vacuumed within %u transactions](./database-must-be-vacuumed-within-transactions.md)
- [database with OID %u must be vacuumed before %u more MultiXactId is used](./database-with-oid-must-be-vacuumed-before-more-multixactid-is-used.md)
