---
message: "invalid MCV size %zu (expected %zu)"
slug: invalid-mcv-size-expected
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/statistics/mcv.c:1090"
  - "postgres/src/backend/statistics/mcv.c:1122"
reproduced: false
---

# `invalid MCV size %zu (expected %zu)`

## What it means

Internal error. Deserializing a most-common-values (MCV) extended-statistics list, the code found a stored size that does not match what the format requires. The placeholders are the found and expected sizes. It is a consistency guard over `pg_statistic_ext_data`.

## When it happens

It fires when the planner reads an MCV statistics object whose serialized blob is malformed or truncated. Ordinary queries do not surface it; it points to damaged extended-statistics data.

## How to fix

This is a can't-happen guard. Rebuild the statistics with `ANALYZE` on the table carrying the statistics object, which rewrites the MCV blob. If it recurs, suspect catalog corruption and report a reproducible case.

## Example

*Illustrative* — a malformed MCV statistics size.

```text
ERROR:  invalid MCV size 40 (expected 64)
```

## Related

- [invalid MVNDistinct size expected at least](./invalid-mvndistinct-size-expected-at-least.md)
- [invalid empty fraction statistic](./invalid-empty-fraction-statistic.md)
