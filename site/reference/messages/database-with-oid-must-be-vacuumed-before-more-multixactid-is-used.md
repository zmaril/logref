---
message: "database with OID %u must be vacuumed before %u more MultiXactId is used"
slug: database-with-oid-must-be-vacuumed-before-more-multixactid-is-used
passthrough: false
api: [ereport]
level: [WARNING]
call_sites:
  - "postgres/src/backend/access/transam/multixact.c:1078"
  - "postgres/src/backend/access/transam/multixact.c:2216"
reproduced: false
---

# `database with OID %u must be vacuumed before %u more MultiXactId is used`

## What it means

A wraparound warning naming a database by OID that must be vacuumed before a stated number of further MultiXactIds can be consumed.

## When it happens

It arises like the by-name MultiXact warning, but from a context where only the database OID is available (for example before the name can be looked up).

## Is this a problem?

Identify the database from its OID (`SELECT datname FROM pg_database WHERE oid = ...`) and vacuum it to freeze old MultiXacts. Ensure autovacuum keeps up; the by-OID form carries the same urgency as the by-name one.

## Example

*Illustrative* — a by-OID MultiXact warning.

```text
WARNING:  database with OID 16401 must be vacuumed before 10000000 more MultiXactId is used
```

## Related

- [database "%s" must be vacuumed before %u more MultiXactId is used](./database-must-be-vacuumed-before-more-multixactid-is-used.md)
- [database with OID %u must be vacuumed within %u transactions](./database-with-oid-must-be-vacuumed-within-transactions.md)
