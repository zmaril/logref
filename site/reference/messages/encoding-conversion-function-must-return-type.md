---
message: "encoding conversion function %s must return type %s"
slug: encoding-conversion-function-must-return-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/conversioncmds.c:94"
reproduced: false
---

# `encoding conversion function %s must return type %s`

## What it means

`CREATE CONVERSION` named a conversion function with the wrong return type. The placeholders are the function name and the required return type. A conversion function must return the specific type PostgreSQL expects (`void` in modern versions, or `int4` historically).

## When it happens

It fires from `CREATE CONVERSION` when the supplied function's signature does not return the required type.

## How to fix

Define the conversion function with the exact signature PostgreSQL requires for encoding conversions, including the return type named in the message. Consult the `CREATE CONVERSION` documentation for the expected function prototype.

## Example

*Illustrative* — a conversion function with a wrong return type.

```text
ERROR:  encoding conversion function myconv must return type void
```

## Related

- [encoding conversion function returned incorrect result for empty input](./encoding-conversion-function-returned-incorrect-result-for-empty-input.md)
- [destination encoding does not exist](./destination-encoding-does-not-exist.md)
