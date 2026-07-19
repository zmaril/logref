---
message: "aggregate must have a transition function"
slug: aggregate-must-have-a-transition-function
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_aggregate.c:116"
reproduced: false
---

# `aggregate must have a transition function`

## What it means

A `CREATE AGGREGATE` did not define a state transition function (`sfunc`), which every aggregate needs to accumulate its result across input rows.

## When it happens

It occurs when the aggregate definition omits `sfunc`, leaving no way to fold each input row into the running state.

## How to fix

Provide an `sfunc` (state transition function) in the aggregate definition. Every aggregate must have one; only the final function and moving-aggregate parts are optional.

## Example

*Illustrative* — an aggregate defined without a transition function.

```text
ERROR:  aggregate must have a transition function
```

## Related

- [aggregate sfunc must be specified](./aggregate-sfunc-must-be-specified.md)
- [aggregate stype must be specified](./aggregate-stype-must-be-specified.md)
