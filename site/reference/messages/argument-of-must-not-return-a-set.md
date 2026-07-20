---
message: "argument of %s must not return a set"
slug: argument-of-must-not-return-a-set
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:1185"
  - "postgres/src/backend/parser/parse_coerce.c:1234"
reproduced: false
---

# `argument of %s must not return a set`

## What it means

A construct that requires a single value was given an argument that returns a set of rows. The message names the construct. Set-returning expressions are not allowed where a scalar is expected, such as certain clause arguments.

## When it happens

Using a set-returning function or a set-valued expression as the argument to a construct that must evaluate to one value — for example a `LIMIT`, `OFFSET`, or similar clause given `generate_series` or another set-returning call.

## How to fix

Replace the argument with a scalar expression. Aggregate or pick a single value from the set, or move the set-returning function into the `FROM` clause and reference one of its values. The construct named in the message must receive a single value, not a set.

## Example

*Illustrative* — a set-returning argument where a scalar is required.

```sql
SELECT * FROM t LIMIT generate_series(1, 3);  -- argument must not return a set
```

## Related

- [argument of must be type not type](./argument-of-must-be-type-not-type.md)
- [set-returning functions are not allowed in](./set-returning-functions-are-not-allowed-in.md)
