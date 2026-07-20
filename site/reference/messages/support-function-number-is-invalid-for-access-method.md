---
message: "support function number %d is invalid for access method %s"
slug: support-function-number-is-invalid-for-access-method
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/access/gin/ginvalidate.c:321"
  - "postgres/src/backend/access/gist/gistvalidate.c:346"
  - "postgres/src/backend/access/spgist/spgvalidate.c:376"
reproduced: false
---

# `support function number %d is invalid for access method %s`

## What it means

An operator-family validation found a support-function entry whose number is not valid for the access method it belongs to. Each access method defines which support-function numbers are meaningful, and this entry used one that is not.

## When it happens

Validating or defining an operator family or class (including during `CREATE`/`ALTER OPERATOR FAMILY` or an access-method validation pass) where a `FUNCTION n` entry uses a number the access method does not define.

## How to fix

Use a support-function number the access method defines. Consult the access method's documentation for its valid support-function numbers, and correct the operator-family entry. If the family comes from an extension, update the extension so its entries match the access method.

## Example

*Illustrative* — an invalid support-function number.

```text
ERROR:  support function number 9 is invalid for access method gin
```

## Related

- [invalid function number must be between 1 and](./invalid-function-number-must-be-between-1-and.md)
- [operator class of access method is missing support function](./operator-class-of-access-method-is-missing-support-function.md)
