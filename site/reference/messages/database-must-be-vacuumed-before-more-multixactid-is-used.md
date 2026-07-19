---
message: "database \"%s\" must be vacuumed before %u more MultiXactId is used"
slug: database-must-be-vacuumed-before-more-multixactid-is-used
passthrough: false
api: [ereport]
level: [WARNING]
call_sites:
  - "postgres/src/backend/access/transam/multixact.c:1067"
  - "postgres/src/backend/access/transam/multixact.c:2205"
reproduced: false
---

# `database "%s" must be vacuumed before %u more MultiXactId is used`

## What it means

A wraparound warning that a database is approaching the MultiXact-ID limit and must be vacuumed before a stated number of further MultiXactIds can be consumed.

## When it happens

It arises when MultiXact usage (from row locking and shared locks) advances toward the wraparound threshold and autovacuum has not yet frozen old MultiXacts fast enough.

## Is this a problem?

Vacuum the named database to freeze old MultiXacts — `VACUUM` (a database-wide vacuum, or targeting the oldest tables). Ensure autovacuum is running and keeping up; ignoring this leads to a forced shutdown to protect data.

## Example

*Illustrative* — approaching the MultiXact limit.

```text
WARNING:  database "app" must be vacuumed before 10000000 more MultiXactId is used
```

## Related

- [database "%s" must be vacuumed within %u transactions](./database-must-be-vacuumed-within-transactions.md)
- [database with OID %u must be vacuumed before %u more MultiXactId is used](./database-with-oid-must-be-vacuumed-before-more-multixactid-is-used.md)
