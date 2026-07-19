---
message: "invalid opclass definition"
slug: invalid-opclass-definition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/access/brin/brin_bloom.c:737"
  - "postgres/src/backend/access/brin/brin_inclusion.c:573"
  - "postgres/src/backend/access/brin/brin_minmax_multi.c:2880"
reproduced: false
---

# `invalid opclass definition`

## What it means

An operator class supplied to an index access method is missing pieces the method requires, so the method rejected it as incomplete. Each access method expects its operator classes to provide a specific set of support functions and operators.

## When it happens

Building or using an index whose operator class does not supply everything the access method needs — usually a custom or extension-provided operator class that is missing a required support function.

## How to fix

Complete the operator-class definition so it provides every operator and support function the access method requires. Consult the access method's documentation for the mandatory members, and add the missing `FUNCTION` or `OPERATOR` entries with `ALTER OPERATOR FAMILY`. If the class comes from an extension, update or reinstall the extension.

## Example

*Illustrative* — an incomplete operator class rejected by the access method.

```text
ERROR:  invalid opclass definition
```

## Related

- [operator class does not exist for access method](./operator-class-does-not-exist-for-access-method.md)
- [operator class of access method is missing support function](./operator-class-of-access-method-is-missing-support-function.md)
