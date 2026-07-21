---
message: "expected %d check constraint on table \"%s\" but found %d"
slug: expected-check-constraint-on-table-but-found
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:9854"
reproduced: false
---

# `expected %d check constraint on table "%s" but found %d`

## What it means

An internal sanity check in `pg_dump`. It expected a specific number of check constraints on a table (based on catalog counts) and found a different number while assembling the dump. The placeholders are the expected and actual counts and the table name.

## When it happens

It fires during `pg_dump` when the catalog view of a table's check constraints is inconsistent with what the dump logic gathered — often a sign of concurrent DDL on the table during the dump, or catalog inconsistency.

## How to fix

Do not run DDL against tables while dumping them; take the dump when the schema is quiescent, or use a snapshot-consistent approach. If nothing changed the schema concurrently, the mismatch may indicate catalog corruption worth investigating. Re-run the dump after the schema settles.

## Example

*Illustrative* — the message as logged.

```
expected 2 check constraints on table "orders" but found 1
```

## Related

- [failed sanity check, relation with OID not found](./failed-sanity-check-relation-with-oid-not-found.md)
- [expected format differs from format found in file](./expected-format-differs-from-format-found-in-file.md)
