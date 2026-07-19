---
message: "final function with extra arguments must not be declared STRICT"
slug: final-function-with-extra-arguments-must-not-be-declared-strict
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/catalog/pg_aggregate.c:394"
  - "postgres/src/backend/catalog/pg_aggregate.c:552"
reproduced: false
---

# `final function with extra arguments must not be declared STRICT`

## What it means

A `CREATE AGGREGATE` declared a final function that takes extra arguments and marked it `STRICT`. A strict final function with extra arguments would be skipped whenever any extra argument is null, which is not allowed for this configuration.

## When it happens

Defining an aggregate with `FINALFUNC_EXTRA` whose final function is `STRICT`. The combination is rejected because null extra arguments are expected and must be handled.

## How to fix

Declare the final function non-strict (`CALLED ON NULL INPUT`) and handle nulls inside it, or remove the extra-arguments requirement from the aggregate definition.

## Example

*Illustrative* — a strict final function with extra args.

```text
ERROR:  final function with extra arguments must not be declared STRICT
```

## Related

- [function should return type](./function-should-return-type.md)
- [expressions are not supported in included columns](./expressions-are-not-supported-in-included-columns.md)
