---
message: "type %u is not a multirange type"
slug: type-is-not-a-multirange-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/multirangetypes.c:435"
  - "postgres/src/backend/utils/adt/multirangetypes.c:561"
  - "postgres/src/backend/utils/adt/multirangetypes.c:1277"
reproduced: false
---

# `type %u is not a multirange type`

## What it means

An operation expected a multirange type but was given a type that is not one. Multirange operations require a multirange type argument, and the supplied type does not qualify.

## When it happens

Calling a multirange function or operation with a type that is a range, a scalar, or another non-multirange type — for example passing a range where its corresponding multirange was expected.

## How to fix

Use the correct multirange type. Each range type has an associated multirange type; pass a value of that multirange type, or construct one from ranges with the appropriate multirange constructor. Check the argument types the function expects.

## Example

*Illustrative* — a non-multirange type where a multirange is required.

```text
ERROR:  type 23 is not a multirange type
```

## Related

- [multirange values cannot contain null members](./multirange-values-cannot-contain-null-members.md)
- [type is not a range type](./type-is-not-a-range-type.md)
