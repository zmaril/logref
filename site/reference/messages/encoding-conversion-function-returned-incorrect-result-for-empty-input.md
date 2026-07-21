---
message: "encoding conversion function %s returned incorrect result for empty input"
slug: encoding-conversion-function-returned-incorrect-result-for-empty-input
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/conversioncmds.c:124"
reproduced: false
---

# `encoding conversion function %s returned incorrect result for empty input`

## What it means

`CREATE CONVERSION` validated the supplied conversion function by passing it empty input, and it returned a non-empty or malformed result. A correct conversion function must return empty output for empty input.

## When it happens

It fires from `CREATE CONVERSION` during the sanity check of the conversion function.

## How to fix

Fix the conversion function so it produces zero output bytes for zero input bytes. A conversion function that mishandles the empty case is buggy; correct its logic before registering it.

## Example

*Illustrative* — a conversion function failing the empty-input check.

```text
ERROR:  encoding conversion function myconv returned incorrect result for empty input
```

## Related

- [encoding conversion function must return type](./encoding-conversion-function-must-return-type.md)
- [encoding conversion failed without error](./encoding-conversion-failed-without-error.md)
