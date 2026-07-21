---
message: "type mismatch in hypothetical-set function"
slug: type-mismatch-in-hypothetical-set-function
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:1152"
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:1160"
reproduced: false
---

# `type mismatch in hypothetical-set function`

## What it means

Internal error. A hypothetical-set aggregate (such as `rank`, `dense_rank`, `percent_rank`, `cume_dist` used as ordered-set aggregates) found the hypothetical argument types not matching the corresponding sort columns. The two must line up by type.

## When it happens

It fires from ordered-set/hypothetical-set aggregate execution when the direct arguments' types disagree with the ordered aggregate columns. Ordinary use with matching types does not raise it.

## How to fix

This is an internal consistency guard, though a malformed custom ordered-set aggregate can provoke it. Ensure any custom hypothetical-set aggregate's argument and sort-column types agree; otherwise capture the query and report it.

## Example

*Illustrative* — mismatched types in a hypothetical-set aggregate.

```text
ERROR:  type mismatch in hypothetical-set function
```

## Related

- [ordered-set aggregate called in non-aggregate context](./ordered-set-aggregate-called-in-non-aggregate-context.md)
- [return type of transition function %s is not %s](./return-type-of-transition-function-is-not.md)
