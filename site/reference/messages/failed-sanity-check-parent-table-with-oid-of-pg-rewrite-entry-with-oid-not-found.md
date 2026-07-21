---
message: "failed sanity check, parent table with OID %u of pg_rewrite entry with OID %u not found"
slug: failed-sanity-check-parent-table-with-oid-of-pg-rewrite-entry-with-oid-not-found
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:8592"
reproduced: false
---

# `failed sanity check, parent table with OID %u of pg_rewrite entry with OID %u not found`

## What it means

A `pg_dump` internal sanity check. It found a `pg_rewrite` entry (a rule or view-defining rule) whose owning table OID does not correspond to any table it gathered. The placeholders are the parent table OID and the `pg_rewrite` entry OID.

## When it happens

It fires during `pg_dump` when the rule-to-table relationship in the catalog is inconsistent with the set of objects the dump collected — typically from concurrent DDL during the dump, or catalog corruption.

## How to fix

Do not run DDL that creates or drops rules, views, or their tables while dumping. Take the dump against a quiescent schema. If no concurrent changes occurred, investigate possible catalog inconsistency. Re-run the dump after the schema settles.

## Example

*Illustrative* — the message as logged.

```
pg_dump: error: failed sanity check, parent table with OID 16400 of pg_rewrite entry with OID 16500 not found
```

## Related

- [failed sanity check, parent OID of table OID not found](./failed-sanity-check-parent-oid-of-table-oid-not-found.md)
- [failed sanity check, relation with OID not found](./failed-sanity-check-relation-with-oid-not-found.md)
