---
message: "associated data types for operator class options parsing functions must match opclass input type"
slug: associated-data-types-for-operator-class-options-parsing-functions-must-match
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/opclasscmds.c:1240"
reproduced: false
---

# `associated data types for operator class options parsing functions must match opclass input type`

## What it means

An operator class defined an options-parsing support function whose associated data type does not match the operator class's input type, so the options function is wired to the wrong type.

## When it happens

It occurs in `CREATE OPERATOR CLASS`/`ALTER OPERATOR FAMILY` when the support function that parses opclass options is declared with a data type that differs from the opclass input type.

## How to fix

Declare the options-parsing support function with the same data type as the operator class's input type. Align the `FUNCTION ... (type)` clause with the opclass so the options function matches.

## Example

*Illustrative* — an options function typed differently from the opclass.

```text
ERROR:  associated data types for operator class options parsing functions must match opclass input type
```

## Related

- [associated data types must be specified for index support function](./associated-data-types-must-be-specified-for-index-support-function.md)
- [access method does not support ordering operators](./access-method-does-not-support-ordering-operators.md)
