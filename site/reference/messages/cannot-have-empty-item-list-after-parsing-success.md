---
message: "cannot have empty item list after parsing success."
slug: cannot-have-empty-item-list-after-parsing-success
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pg_ndistinct.c:606"
reproduced: false
---

# `cannot have empty item list after parsing success.`

## What it means

An internal guard in the n-distinct statistics code fired: parsing reported success but produced an empty item list. A successful parse of the multivariate n-distinct value must yield at least one item, so an empty result is contradictory.

## When it happens

It is reached while deserializing a stored `pg_ndistinct` value whose bytes parsed without error yet yielded nothing. It usually points to a corrupted or malformed statistics value rather than a user action.

## How to fix

There is no user-level fix. If it appears, the extended-statistics object is likely damaged: drop and recreate the statistics with `DROP STATISTICS` and `CREATE STATISTICS`, then re-run `ANALYZE`. If it recurs, capture the object and report it.

## Example

*Illustrative* — an empty item list after a successful parse.

```text
ERROR:  cannot have empty item list after parsing success.
```

## Related

- [cannot have more than columns in statistics](./cannot-have-more-than-columns-in-statistics.md)
- [cannot happen](./cannot-happen.md)
