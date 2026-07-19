---
message: "unrecognized table OID %u"
slug: unrecognized-table-oid
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:8048"
  - "postgres/src/bin/pg_dump/pg_dump.c:8342"
  - "postgres/src/bin/pg_dump/pg_dump.c:8805"
  - "postgres/src/bin/pg_dump/pg_dump.c:9461"
  - "postgres/src/bin/pg_dump/pg_dump.c:9605"
  - "postgres/src/bin/pg_dump/pg_dump.c:9750"
  - "postgres/src/bin/pg_dump/pg_dump.c:9850"
reproduced: false
---

# `unrecognized table OID %u`

## What it means

During a dump, `pg_dump` encountered a table OID it did not register in its internal catalog of objects. The placeholder is the OID. `pg_dump` builds a map of all objects up front; an OID that is not in the map indicates an inconsistency between what it enumerated and what a later query returned.

## When it happens

A `pg_dump` version mismatch with the server, concurrent DDL that created a table after `pg_dump` took its object snapshot, or catalog inconsistency. Concurrent schema changes during a dump are the usual cause.

## How to fix

Avoid DDL that adds tables while a dump is running — `pg_dump` is not designed for a schema changing underneath it. Use a matching (or newer) `pg_dump` version. Re-run the dump when no concurrent DDL is happening; a serializable snapshot helps but concurrent creates can still confuse object enumeration. Report reproducible cases with matching versions and no concurrency.

## Example

*Illustrative* — a table created during a dump.

```text
pg_dump: error: unrecognized table OID 16999
```

## Related

- [could not parse %s array](./could-not-parse-array.md)
- [cache lookup failed for relation](./cache-lookup-failed-for-relation-0e5774.md)
