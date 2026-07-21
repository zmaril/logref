---
message: "operator class \"%s\" of access method %s is missing support function %d"
slug: operator-class-of-access-method-is-missing-support-function
passthrough: false
api: [ereport]
level: [INFO]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/access/brin/brin_validate.c:261"
  - "postgres/src/backend/access/gin/ginvalidate.c:239"
  - "postgres/src/backend/access/gist/gistvalidate.c:270"
reproduced: false
---

# `operator class "%s" of access method %s is missing support function %d`

## What it means

An informational report from operator-family validation, noting that an operator class does not provide a support function the access method expects. It is emitted by validation routines to surface incomplete operator classes, at info level.

## When it happens

Running access-method validation, such as `amvalidate` during operator-family checks or an `ALTER OPERATOR FAMILY` validation pass, where a class lacks a support function the method looks for.

## Is this a problem?

Treat it as a completeness report. If the class should support the function, add it with `ALTER OPERATOR FAMILY`, or update the extension that provides the class. Some missing support functions are optional, so confirm whether the access method truly requires the named one before acting.

## Example

*Illustrative* — a validation report of a missing support function.

```text
INFO:  operator class "my_ops" of access method gist is missing support function 8
```

## Related

- [support function number is invalid for access method](./support-function-number-is-invalid-for-access-method.md)
- [invalid opclass definition](./invalid-opclass-definition.md)
