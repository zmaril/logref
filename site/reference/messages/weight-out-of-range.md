---
message: "weight out of range"
slug: weight-out-of-range
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/tsrank.c:455"
  - "postgres/src/backend/utils/adt/tsrank.c:897"
reproduced: false
---

# `weight out of range`

## What it means

A full-text-search weight argument was outside the allowed set of weight labels, so the operation was rejected.

## When it happens

It arises from `setweight()` and related `tsvector` functions when the weight is not one of the four labels `A`, `B`, `C`, or `D`.

## How to fix

Pass a weight of `A`, `B`, `C`, or `D` (uppercase). These are the only weights `tsvector` supports; map any custom scheme onto those four labels.

## Example

*Illustrative* — an invalid tsvector weight.

```text
ERROR:  weight out of range
```

## Related

- [unrecognized format() type specifier "%.*s"](./unrecognized-format-type-specifier.md)
- [value %s out of bounds for option "%s"](./value-out-of-bounds-for-option.md)
