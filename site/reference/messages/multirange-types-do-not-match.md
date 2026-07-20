---
message: "multirange types do not match"
slug: multirange-types-do-not-match
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/multirangetypes.c:1955"
  - "postgres/src/backend/utils/adt/multirangetypes.c:2664"
reproduced: false
---

# `multirange types do not match`

## What it means

Internal error. A multirange operation received two multirange values of different multirange types where the same type was required. It is a type-consistency guard in multirange support code.

## When it happens

It fires in internal multirange combining/comparison paths when the operand types disagree. Ordinary SQL usually reports a type mismatch earlier at parse time; reaching this guard points to an internal inconsistency.

## How to fix

This is a can't-happen guard for normal SQL. If a custom C function assembles multiranges, check that it uses matching multirange types. Otherwise capture the query and report a reproducible case.

## Example

*Illustrative* — mismatched multirange operand types.

```text
ERROR:  multirange types do not match
```

## Related

- [number is out of range](./number-is-out-of-range.md)
- [operator class does not accept data type](./operator-class-does-not-accept-data-type.md)
