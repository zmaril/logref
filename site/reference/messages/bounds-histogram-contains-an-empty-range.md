---
message: "bounds histogram contains an empty range"
slug: bounds-histogram-contains-an-empty-range
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/multirangetypes_selfuncs.c:509"
  - "postgres/src/backend/utils/adt/rangetypes_selfuncs.c:423"
reproduced: false
---

# `bounds histogram contains an empty range`

## What it means

Internal error. Range or multirange selectivity estimation read a bounds histogram that contains an empty range, which the estimator does not expect there. It is a consistency check on the statistics the planner uses to estimate range-query selectivity.

## When it happens

It should not occur for statistics gathered through normal `ANALYZE`. Reaching it points to an internal inconsistency in the range-type statistics, not to your query as such.

## How to fix

Treat it as an internal-bug signal. Re-running `ANALYZE` on the table to rebuild the statistics may clear it; if it recurs, capture the query and the column's type and report it.

## Example

*Illustrative* — an empty range in a bounds histogram.

```text
ERROR:  bounds histogram contains an empty range
```

## Related

- [invalid range bound flags](./invalid-range-bound-flags.md)
- [multirange values cannot contain null members](./multirange-values-cannot-contain-null-members.md)
