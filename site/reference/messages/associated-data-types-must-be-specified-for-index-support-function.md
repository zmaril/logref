---
message: "associated data types must be specified for index support function"
slug: associated-data-types-must-be-specified-for-index-support-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/opclasscmds.c:1423"
reproduced: false
---

# `associated data types must be specified for index support function`

## What it means

An operator-class support function was declared without the associated data types the access method needs to know which types it applies to, so the function cannot be placed in the operator family correctly.

## When it happens

It occurs in `CREATE OPERATOR CLASS`/`ALTER OPERATOR FAMILY` when a support `FUNCTION` is added without the `(lefttype, righttype)` the method requires for that function slot.

## How to fix

Specify the associated data types for the support function, for example `FUNCTION n (type1, type2) funcname`. Provide the type pair the access method expects so the support function is registered against the right types.

## Example

*Illustrative* — a support function missing its associated types.

```text
ERROR:  associated data types must be specified for index support function
```

## Related

- [associated data types for operator class options parsing functions must match](./associated-data-types-for-operator-class-options-parsing-functions-must-match.md)
- [access method does not support ordering operators](./access-method-does-not-support-ordering-operators.md)
