---
message: "expected one dependency record for TOAST table, found %ld"
slug: expected-one-dependency-record-for-toast-table-found
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/repack.c:1844"
  - "postgres/src/backend/commands/repack.c:1853"
reproduced: false
---

# `expected one dependency record for TOAST table, found %ld`

## What it means

Internal error during a repack/rewrite. When looking up the dependency linking a TOAST table to its owning table, the code found a number of records other than the single one it expects. The `%ld` is the count.

## When it happens

It fires during table rewriting when `pg_depend` holds an unexpected number of dependency rows for a TOAST table. Ordinary queries do not reach it; it can indicate catalog inconsistency.

## How to fix

This is a consistency check. Inspect `pg_depend` for the TOAST table's dependencies. An abnormal count points at catalog damage; capture the details and report a reproducible case.

## Example

*Illustrative* — an unexpected dependency count for a TOAST table.

```text
ERROR:  expected one dependency record for TOAST table, found 0
```

## Related

- [failed sanity check, parent table with OID of sequence with OID not found](./failed-sanity-check-parent-table-with-oid-of-sequence-with-oid-not-found.md)
- [could not find tuple for constraint](./could-not-find-tuple-for-constraint.md)
