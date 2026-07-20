---
message: "no binary output function available for type %s"
slug: no-binary-output-function-available-for-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:1591"
  - "postgres/src/backend/utils/adt/multirangetypes.c:456"
  - "postgres/src/backend/utils/adt/rangetypes.c:360"
  - "postgres/src/backend/utils/cache/lsyscache.c:3305"
reproduced: false
---

# `no binary output function available for type %s`

## What it means

A value was requested in binary wire format for a type that has no binary send function. The placeholder names the type. The binary (`send`) function is optional; without it the type can only be delivered as text.

## When it happens

A client asked for results in binary format for a column whose type lacks a binary output function, or a binary-format `COPY TO` includes such a column.

## How to fix

Request results in text format for that column or statement, or use text-format `COPY TO`. If you own the type and need binary output, add a `SEND` function to its definition. Not a data error — the type simply does not offer binary encoding.

## Example

*Illustrative* — binary output requested for a type without a send function.

```text
ERROR:  no binary output function available for type myshell
```

## Related

- [no binary input function available for type](./no-binary-input-function-available-for-type.md)
- [cannot determine result data type](./cannot-determine-result-data-type.md)
