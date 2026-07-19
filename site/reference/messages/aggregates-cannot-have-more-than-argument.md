---
message: "aggregates cannot have more than %d argument"
slug: aggregates-cannot-have-more-than-argument
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TOO_MANY_ARGUMENTS
    code: "54023"
call_sites:
  - "postgres/src/backend/catalog/pg_aggregate.c:127"
reproduced: false
---

# `aggregates cannot have more than %d argument`

## What it means

A `CREATE AGGREGATE` declared more argument columns than an aggregate is allowed to have, exceeding the built-in limit on aggregate arguments.

## When it happens

It occurs when defining an aggregate whose argument list is longer than the maximum the server supports.

## How to fix

Reduce the number of aggregate arguments to within the limit stated in the message. If you need to pass more values, group them into a composite type or array and accept that single argument instead.

## Example

*Illustrative* — an aggregate with too many arguments.

```text
ERROR:  aggregates cannot have more than 8 argument
```

## Related

- [aggregate input type must be specified](./aggregate-input-type-must-be-specified.md)
- [aggregates cannot accept set arguments](./aggregates-cannot-accept-set-arguments.md)
