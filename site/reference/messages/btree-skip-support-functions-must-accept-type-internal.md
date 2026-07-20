---
message: "btree skip support functions must accept type \"internal\""
slug: btree-skip-support-functions-must-accept-type-internal
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/opclasscmds.c:1356"
reproduced: false
---

# `btree skip support functions must accept type "internal"`

## What it means

A B-tree skip-support function was defined with a signature that does not take the `internal` type. Skip support is an optional B-tree operator-class function, and its calling convention requires an `internal` argument.

## When it happens

It occurs when defining or registering a B-tree operator class or family with a skip-support function whose declared argument type is not `internal`.

## How to fix

Declare the skip-support function to accept `internal` as required by the B-tree support-function contract. Follow the operator-class documentation for the exact signature of each support-function number.

## Example

*Illustrative* — a skip-support function with the wrong signature.

```text
ERROR:  btree skip support functions must accept type "internal"
```

## Related

- [btree skip support functions must not be cross-type](./btree-skip-support-functions-must-not-be-cross-type.md)
- [basetype is redundant with aggregate input type specification](./basetype-is-redundant-with-aggregate-input-type-specification.md)
