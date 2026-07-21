---
message: "could not identify dependency loop"
slug: could-not-identify-dependency-loop
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump_sort.c:831"
reproduced: false
---

# `could not identify dependency loop`

## What it means

`pg_dump` was ordering objects so each is created after everything it depends on, hit a cycle, and could not find a place to break it. It reports this when its loop-breaking logic cannot resolve a circular dependency.

## When it happens

It happens during a dump when objects reference each other in a cycle the dumper cannot untangle — an unusual situation, sometimes involving unusual dependency shapes or catalog inconsistency.

## How to fix

This is an internal guard in `pg_dump`. Note the objects reported around the failure, since simplifying an unusual circular dependency in the schema can avoid it. If it occurs on a normal, consistent database, capture the schema and report a reproducible case.

## Example

*Illustrative* — an unbreakable dependency cycle during dump.

```text
pg_dump: fatal: could not identify dependency loop
```

## Related

- [could not identify relation associated with constraint](./could-not-identify-relation-associated-with-constraint.md)
- [could not get server version](./could-not-get-server-version.md)
