---
message: "could not find function definition for function with OID %u"
slug: could-not-find-function-definition-for-function-with-oid
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:13869"
  - "postgres/src/bin/pg_dump/pg_dump.c:13975"
  - "postgres/src/bin/pg_dump/pg_dump.c:13982"
reproduced: false
---

# `could not find function definition for function with OID %u`

## What it means

`pg_dump` could not find the definition of a function referenced by OID while assembling the dump. The placeholder is the function OID. Something in the database (a default, a dependency) pointed at a function whose `pg_proc` entry the dump could not resolve.

## When it happens

Dumping a database whose catalog references a function that is missing or inconsistent — often a symptom of catalog corruption, or a concurrent drop during the dump.

## How to fix

If a concurrent `DROP FUNCTION` ran during the dump, re-run the dump on a quiescent database. If it recurs, look for the OID in `pg_proc`; a dangling reference indicates catalog inconsistency to investigate, and restoring from a consistent backup or repairing the offending dependency is the path. Report reproducible cases.

## Example

*Illustrative* — a dangling function reference during dump.

```text
pg_dump: error: could not find function definition for function with OID 16640
```

## Related

- [could not find multirange type for data type](./could-not-find-multirange-type-for-data-type.md)
- [proallargtypes is not a 1-D Oid array or it contains nulls](./proallargtypes-is-not-a-1-d-oid-array-or-it-contains-nulls.md)
