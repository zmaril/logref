---
message: "invalid empty fraction statistic"
slug: invalid-empty-fraction-statistic
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/multirangetypes_selfuncs.c:318"
  - "postgres/src/backend/utils/adt/rangetypes_selfuncs.c:257"
reproduced: false
---

# `invalid empty fraction statistic`

## What it means

Internal error. Extended-statistics code found an empty-fraction value that is outside the valid `[0,1]` range while reading a statistics object. It is a consistency guard over stored statistics.

## When it happens

It fires when the planner or `ANALYZE` machinery reads an extended-statistics entry whose stored fraction is malformed. Ordinary queries do not surface it; it points to damaged `pg_statistic_ext_data` contents.

## How to fix

This is a can't-happen guard. Rebuild the statistics with `ANALYZE` on the affected table, which rewrites the statistics rows. If it recurs, suspect catalog corruption and report a reproducible case with the statistics object involved.

## Example

*Illustrative* — a malformed extended-statistics fraction.

```text
ERROR:  invalid empty fraction statistic
```

## Related

- [invalid MCV size expected](./invalid-mcv-size-expected.md)
- [invalid MVNDistinct size expected at least](./invalid-mvndistinct-size-expected-at-least.md)
