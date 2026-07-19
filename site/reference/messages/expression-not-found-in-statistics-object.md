---
message: "expression not found in statistics object"
slug: expression-not-found-in-statistics-object
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/statistics/mcv.c:1571"
reproduced: false
---

# `expression not found in statistics object`

## What it means

An internal guard in extended-statistics handling. The planner looked for a specific expression among a statistics object's tracked expressions and did not find it. It is a lookup invariant, not a user-facing validation.

## When it happens

It fires while the planner uses an extended-statistics object (`CREATE STATISTICS`) and the expression it expects to be covered is absent from the object's definition. In normal operation the tracked expressions and the planner's expectations agree.

## How to fix

This is an internal invariant rather than something you configure directly. If it appears, the statistics object and the query may be out of sync — try `ANALYZE` on the table, or drop and recreate the `CREATE STATISTICS` object. Capture the statistics definition and the query and report it if it persists.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expression not found in statistics object
```

## Related

- [expression contains variables of more than one relation](./expression-contains-variables-of-more-than-one-relation.md)
- [expected element float8 array](./expected-element-float8-array.md)
