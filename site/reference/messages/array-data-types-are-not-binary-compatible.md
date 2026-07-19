---
message: "array data types are not binary-compatible"
slug: array-data-types-are-not-binary-compatible
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:1734"
reproduced: false
---

# `array data types are not binary-compatible`

## What it means

An operation tried to treat one array type as another without a real conversion, but their element types are not binary-compatible, so the reinterpretation is unsafe and rejected.

## When it happens

It occurs when a binary-coercion path between two array types is attempted (for example an unsupported cast) whose element types do not have identical storage representations.

## How to fix

Use an explicit element-wise conversion rather than assuming binary compatibility — for example unnest, cast each element, and re-aggregate, or apply a defined cast between the array types. Do not force a binary cast between array types with different element representations.

## Example

*Illustrative* — a binary cast between incompatible array types.

```text
ERROR:  array data types are not binary-compatible
```

## Related

- [argument of cast function must match or be binary-coercible from source data type](./argument-of-cast-function-must-match-or-be-binary-coercible-from-source-data.md)
- [array element type cannot be](./array-element-type-cannot-be.md)
