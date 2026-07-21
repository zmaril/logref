---
message: "missing row in percentile_disc"
slug: missing-row-in-percentile-disc
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:481"
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:486"
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:820"
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:824"
reproduced: false
---

# `missing row in percentile_disc`

## What it means

Internal error. The `percentile_disc` ordered-set aggregate walked its sorted input looking for the row at the target percentile position and ran off the end without finding it. It is a consistency check: the computed position should always land on a real row.

## When it happens

It should not occur through normal SQL. Reaching it points to an internal inconsistency in the ordered-set aggregate machinery rather than to anything in your query or data.

## How to fix

Treat it as an internal bug. Capture the exact `percentile_disc(...) WITHIN GROUP (ORDER BY ...)` call and the input that produced it, and report it. There is no data-side change that is expected to trigger or avoid it.

## Example

*Illustrative* — emitted internally by the ordered-set aggregate.

```text
ERROR:  missing row in percentile_disc
```

## Related

- [percentile value is not between 0 and 1](./percentile-value-is-not-between-0-and-1.md)
- [more than one row returned by a subquery used as an expression](./more-than-one-row-returned-by-a-subquery-used-as-an-expression.md)
