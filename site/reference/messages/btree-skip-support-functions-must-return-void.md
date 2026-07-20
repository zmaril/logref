---
message: "btree skip support functions must return void"
slug: btree-skip-support-functions-must-return-void
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/opclasscmds.c:1360"
reproduced: false
---

# `btree skip support functions must return void`

## What it means

A B-tree skip-support function was defined with a return type other than `void`. The skip-support role in a B-tree operator class must return `void`, since it communicates through its `internal` argument rather than a return value.

## When it happens

It occurs when defining or registering a B-tree operator class or family with a skip-support function whose declared return type is not `void`.

## How to fix

Declare the skip-support function to return `void`. Follow the operator-class documentation for the exact signature required of each support-function number.

## Example

*Illustrative* — a skip-support function with a non-void return.

```text
ERROR:  btree skip support functions must return void
```

## Related

- [btree skip support functions must accept type internal](./btree-skip-support-functions-must-accept-type-internal.md)
- [btree skip support functions must not be cross-type](./btree-skip-support-functions-must-not-be-cross-type.md)
