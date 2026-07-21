---
message: "array_agg_transfn called in non-aggregate context"
slug: array-agg-transfn-called-in-non-aggregate-context
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/array_userfuncs.c:577"
reproduced: false
---

# `array_agg_transfn called in non-aggregate context`

## What it means

The internal transition function behind `array_agg` was invoked outside an aggregate evaluation, which should never happen — an internal guard confirming it is only reachable through aggregation machinery.

## When it happens

It is raised if the `array_agg` transition function is called directly rather than by the aggregate executor, normally only through misuse from C code or an extension.

## How to fix

This is an internal invariant, not a SQL-level issue. Use `array_agg` as an aggregate in a query rather than calling its internal support function. If an extension provokes it, report it there.

## Example

*Illustrative* — the array_agg transition function used directly.

```text
ERROR:  array_agg_transfn called in non-aggregate context
```

## Related

- [array_agg_array_transfn called in non-aggregate context](./array-agg-array-transfn-called-in-non-aggregate-context.md)
- [aggregate function cannot register a callback in this context](./aggregate-function-cannot-register-a-callback-in-this-context.md)
