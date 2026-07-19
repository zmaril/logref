---
message: "corrupt MVNDistinct entry"
slug: corrupt-mvndistinct-entry
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/selfuncs.c:4823"
reproduced: false
---

# `corrupt MVNDistinct entry`

## What it means

The planner read a multivariate n-distinct extended-statistics entry that is malformed. The serialized statistic could not be interpreted, so it is treated as corrupt. This is an internal check.

## When it happens

It fires during planning when reading `pg_statistic_ext_data` n-distinct data whose stored form is invalid, possibly from corruption or an incompatible upgrade.

## How to fix

Rebuild the extended statistics with `ANALYZE` on the table, which rewrites the entry. If it persists, drop and recreate the `CREATE STATISTICS` object. Persistent corruption of catalog data warrants a storage/integrity check.

## Example

*Illustrative* — a malformed n-distinct statistic.

```text
ERROR:  corrupt MVNDistinct entry
```

## Related

- [corrupted hashtable](./corrupted-hashtable.md)
- [corrupted line pointer](./corrupted-line-pointer.md)
