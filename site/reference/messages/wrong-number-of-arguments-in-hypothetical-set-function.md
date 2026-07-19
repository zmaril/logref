---
message: "wrong number of arguments in hypothetical-set function"
slug: wrong-number-of-arguments-in-hypothetical-set-function
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:1195"
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:1333"
reproduced: false
---

# `wrong number of arguments in hypothetical-set function`

## What it means

Internal error. A hypothetical-set aggregate (such as `rank`/`dense_rank`/`percent_rank` used with `WITHIN GROUP`) was called with a number of direct arguments that does not match its ordering columns.

## When it happens

It fires when the count of hypothetical arguments and the count of `ORDER BY` columns in the `WITHIN GROUP` clause disagree at execution time. A well-formed call is checked earlier, so this points to an internal inconsistency.

## How to fix

This is an internal guard. If a real `WITHIN GROUP` query triggers it, capture the query and report it as a reproducible bug; verify the direct-argument count matches the ordering columns.

## Example

*Illustrative* — a mismatched hypothetical-set call.

```text
ERROR:  wrong number of arguments in hypothetical-set function
```

## Related

- [wrong number of tlist entries](./wrong-number-of-tlist-entries.md)
- [wrong result type supplied in RETURN NEXT](./wrong-result-type-supplied-in-return-next-c25cc9.md)
