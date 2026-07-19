---
message: "invalid MVNDistinct size %zu (expected at least %zu)"
slug: invalid-mvndistinct-size-expected-at-least
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/statistics/mvdistinct.c:260"
  - "postgres/src/backend/statistics/mvdistinct.c:286"
reproduced: false
---

# `invalid MVNDistinct size %zu (expected at least %zu)`

## What it means

Internal error. Deserializing a multivariate n-distinct extended-statistics object, the code found a stored size smaller than the format's minimum. The placeholders are the found size and the minimum expected. It is a consistency guard over `pg_statistic_ext_data`.

## When it happens

It fires when the planner reads an ndistinct statistics object whose serialized blob is truncated or malformed. Ordinary queries do not surface it; it points to damaged extended-statistics data.

## How to fix

This is a can't-happen guard. Rebuild the statistics with `ANALYZE` on the table carrying the statistics object, which rewrites the blob. If it recurs, suspect catalog corruption and report a reproducible case.

## Example

*Illustrative* — a too-small ndistinct statistics blob.

```text
ERROR:  invalid MVNDistinct size 8 (expected at least 16)
```

## Related

- [invalid MCV size expected](./invalid-mcv-size-expected.md)
- [invalid empty fraction statistic](./invalid-empty-fraction-statistic.md)
