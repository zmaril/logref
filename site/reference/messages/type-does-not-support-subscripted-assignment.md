---
message: "type %s does not support subscripted assignment"
slug: type-does-not-support-subscripted-assignment
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/executor/execExpr.c:3383"
  - "postgres/src/backend/executor/execExpr.c:3405"
reproduced: false
---

# `type %s does not support subscripted assignment`

## What it means

An assignment through a subscript (`value[i] = ...`) was attempted on a type that supports reading by subscript but not writing by subscript. The placeholder is the type. Not every subscriptable type defines subscripted assignment.

## When it happens

It arises when assigning into a subscript of a type whose subscript handler implements fetch but not store — for example some custom subscriptable types, or a container that only permits read subscripting in the context used.

## How to fix

Build a new value rather than assigning into a subscript, or use a function the type provides for producing modified values. For custom types, subscripted assignment requires the type's subscript handler to implement the store path.

## Example

*Illustrative* — subscripted assignment on an unsupported type.

```text
ERROR:  type jsonb does not support subscripted assignment
```

## Related

- [subscript type %s is not supported](./subscript-type-is-not-supported.md)
- [type modifier cannot be specified for shell type "%s"](./type-modifier-cannot-be-specified-for-shell-type.md)
