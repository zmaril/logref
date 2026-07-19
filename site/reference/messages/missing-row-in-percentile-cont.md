---
message: "missing row in percentile_cont"
slug: missing-row-in-percentile-cont
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:582"
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:586"
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:598"
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:949"
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:953"
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:974"
reproduced: false
---

# `missing row in percentile_cont`

## What it means

Internal error. The `percentile_cont` ordered-set aggregate interpolates between two sorted rows and expected a row to be present in its buffered tuplesort at the computed position, but the fetch returned nothing. It is a consistency check on the aggregate's own sorted state.

## When it happens

It should not occur for well-formed input. Reaching it suggests a bug in the ordered-set aggregate machinery or corrupted sort state, not a problem with your data.

## How to fix

Treat it as an internal bug. If reproducible, capture the query and the input distribution and report it. There is no user-side configuration that legitimately triggers it.

## Example

*Illustrative* — emitted internally by the percentile aggregate.

```text
ERROR:  missing row in percentile_cont
```

## Related

- [invalid tuplestore state](./invalid-tuplestore-state.md)
- [unrecognized result from subplan](./unrecognized-result-from-subplan.md)
