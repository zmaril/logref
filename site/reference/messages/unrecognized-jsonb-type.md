---
message: "unrecognized jsonb type: %d"
slug: unrecognized-jsonb-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:1843"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:3199"
reproduced: false
---

# `unrecognized jsonb type: %d`

## What it means

Internal error. Code switching on a `jsonb` container type found a type code outside the object/array/scalar set it recognizes.

## When it happens

It fires from `jsonb` traversal or output when the container header carries an unexpected type — a sign of a malformed or corrupt value, not of ordinary input.

## How to fix

This is an internal guard. If a stored value provokes it, the datum may be corrupt; capture the row and column and report it, and re-derive the value from its source to restore a clean copy.

## Example

*Illustrative* — an unrecognized jsonb container type.

```text
ERROR:  unrecognized jsonb type: 48
```

## Related

- [unexpected jsonb value type: %d](./unexpected-jsonb-value-type-92f4ff.md)
- [unrecognized JsonExpr op: %d](./unrecognized-jsonexpr-op.md)
