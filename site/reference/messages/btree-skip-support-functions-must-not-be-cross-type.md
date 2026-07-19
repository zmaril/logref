---
message: "btree skip support functions must not be cross-type"
slug: btree-skip-support-functions-must-not-be-cross-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/opclasscmds.c:1373"
reproduced: false
---

# `btree skip support functions must not be cross-type`

## What it means

A B-tree skip-support function was registered with different left and right input types, but skip support must be a single-type function. Cross-type support functions are not valid for the skip-support role.

## When it happens

It occurs when adding a skip-support function to a B-tree operator class or family with a cross-type signature.

## How to fix

Register the skip-support function with a single data type for both operands rather than a cross-type pair. Use cross-type entries only for the support-function roles that permit them, per the operator-class documentation.

## Example

*Illustrative* — a cross-type skip-support function.

```text
ERROR:  btree skip support functions must not be cross-type
```

## Related

- [btree skip support functions must accept type internal](./btree-skip-support-functions-must-accept-type-internal.md)
- [basetype is redundant with aggregate input type specification](./basetype-is-redundant-with-aggregate-input-type-specification.md)
