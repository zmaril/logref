---
message: "cannot check relation \"%s\""
slug: cannot-check-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/contrib/amcheck/verify_heapam.c:337"
reproduced: false
---

# `cannot check relation "%s"`

## What it means

A relation-verification routine could not process the named relation because its kind or state is not one the check supports. The placeholder is the relation name.

## When it happens

It occurs when running an integrity check against a relation that the checker does not handle — for example a relation kind outside the check's scope.

## How to fix

Point the check at a supported relation kind in a checkable state. Review the verification tool's documentation for the relation kinds it accepts.

## Example

*Illustrative* — checking an unsupported relation.

```text
ERROR:  cannot check relation "r"
```

## Related

- [cannot check index](./cannot-check-index.md)
- [cannot check file compression not supported by this build](./cannot-check-file-compression-with-not-supported-by-this-build.md)
