---
message: "element type cannot be specified without a subscripting function"
slug: element-type-cannot-be-specified-without-a-subscripting-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:516"
reproduced: false
---

# `element type cannot be specified without a subscripting function`

## What it means

`CREATE TYPE` gave an `ELEMENT` type but no `SUBSCRIPT` function. A type's element type is only meaningful if the type supports subscripting, which requires a subscripting handler.

## When it happens

It fires from `CREATE TYPE` when the definition sets `ELEMENT` without also providing a `SUBSCRIPT` function.

## How to fix

Provide a `SUBSCRIPT` function in the `CREATE TYPE` when you set an `ELEMENT` type, or drop the `ELEMENT` clause if the type is not subscriptable. The subscripting function defines how `type[i]` behaves.

## Example

*Illustrative* — ELEMENT without SUBSCRIPT.

```sql
CREATE TYPE mytype (INPUT = ..., OUTPUT = ..., ELEMENT = int4);
-- element type cannot be specified without a subscripting function
```

## Related

- [domain data types must not be marked binary-compatible](./domain-data-types-must-not-be-marked-binary-compatible.md)
- [enum data types are not binary-compatible](./enum-data-types-are-not-binary-compatible.md)
