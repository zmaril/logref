---
message: "argument of cast function must match or be binary-coercible from source data type"
slug: argument-of-cast-function-must-match-or-be-binary-coercible-from-source-data
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:1631"
reproduced: false
---

# `argument of cast function must match or be binary-coercible from source data type`

## What it means

A `CREATE CAST` named a function whose argument type is neither the same as the cast's source type nor binary-coercible from it, so the function cannot receive the source value.

## When it happens

It occurs when defining a cast with a conversion function whose first parameter does not match the declared source type of the cast.

## How to fix

Make the cast function's first argument the cast's source type, or a type the source is binary-coercible to. Align the function signature with the `CREATE CAST (source AS target)` types, and add intermediate casts if a direct match is not possible.

## Example

*Illustrative* — a cast function whose argument does not match the source type.

```text
ERROR:  argument of cast function must match or be binary-coercible from source data type
```

## Related

- [array data types are not binary-compatible](./array-data-types-are-not-binary-compatible.md)
- [argument types and cannot be matched](./argument-types-and-cannot-be-matched.md)
