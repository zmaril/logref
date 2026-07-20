---
message: "no binary input function available for type %s"
slug: no-binary-input-function-available-for-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:1380"
  - "postgres/src/backend/utils/adt/multirangetypes.c:451"
  - "postgres/src/backend/utils/adt/rangetypes.c:355"
  - "postgres/src/backend/utils/cache/lsyscache.c:3272"
reproduced: false
---

# `no binary input function available for type %s`

## What it means

A value was requested in binary wire format for a type that has no binary receive function. The placeholder names the type. Every type has a text input function, but the binary (`recv`) function is optional; without it the type simply cannot be read in binary format.

## When it happens

A client library sends a parameter in binary format for a column or type that lacks a binary input function, or a `COPY ... WITH (FORMAT binary)` targets a column of such a type.

## How to fix

Send that value in text format instead of binary — most drivers let you force text encoding for a parameter or for the whole statement — or use text-format `COPY`. If you control the type and need binary support, add a `RECEIVE` function to its `CREATE TYPE`. This is a limitation of the type, not a data error.

## Example

*Illustrative* — binary input requested for a type without a recv function.

```text
ERROR:  no binary input function available for type myshell
```

## Related

- [no binary output function available for type](./no-binary-output-function-available-for-type.md)
- [insufficient data left in message](./insufficient-data-left-in-message.md)
