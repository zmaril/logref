---
message: "failed sanity check, parent table with OID %u of sequence with OID %u not found"
slug: failed-sanity-check-parent-table-with-oid-of-sequence-with-oid-not-found
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:7644"
  - "postgres/src/bin/pg_dump/pg_dump.c:19409"
reproduced: false
---

# `failed sanity check, parent table with OID %u of sequence with OID %u not found`

## What it means

`pg_dump` ran an internal sanity check and could not find the parent table that an identity/owned sequence belongs to. The `%u` values are the parent-table and sequence OIDs. The catalog link the dump relied on was missing.

## When it happens

The source catalog was inconsistent, or objects were dropped concurrently during the dump, so a sequence's owning table could not be resolved.

## How to fix

Dump from a quiescent source so objects are not dropped mid-run. If it recurs on a static database, the catalog may be damaged — investigate `pg_depend`/`pg_class` for the sequence and report a reproducible case.

## Example

*Illustrative* — a sequence's parent table was not found.

```text
pg_dump: error: failed sanity check, parent table with OID 16384 of sequence with OID 16390 not found
```

## Related

- [error message from server](./error-message-from-server.md)
- [expected one dependency record for TOAST table, found](./expected-one-dependency-record-for-toast-table-found.md)
