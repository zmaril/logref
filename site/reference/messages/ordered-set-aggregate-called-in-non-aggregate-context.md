---
message: "ordered-set aggregate called in non-aggregate context"
slug: ordered-set-aggregate-called-in-non-aggregate-context
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:127"
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:144"
reproduced: false
---

# `ordered-set aggregate called in non-aggregate context`

## What it means

Internal error. The support code for an ordered-set aggregate (such as `percentile_cont` or `mode`) was invoked outside a valid aggregate evaluation context, where the per-group state it depends on is not available.

## When it happens

It fires when an ordered-set aggregate's final or transition function is reached without the aggregate execution context the executor normally sets up. It signals a mismatch between a function marked as an ordered-set aggregate and how it was called.

## How to fix

This is an internal guard. If it appears from ordinary SQL, capture the query and the aggregate definition involved and report it; a custom aggregate declared with the wrong kind can also provoke it.

## Example

*Illustrative* — an ordered-set aggregate reached outside aggregation.

```text
ERROR:  ordered-set aggregate called in non-aggregate context
```

## Related

- [type mismatch in hypothetical-set function](./type-mismatch-in-hypothetical-set-function.md)
- [return type of transition function %s is not %s](./return-type-of-transition-function-is-not.md)
