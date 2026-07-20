---
message: "compress method must be defined when leaf type is different from input type"
slug: compress-method-must-be-defined-when-leaf-type-is-different-from-input-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/access/spgist/spgutils.c:250"
reproduced: false
---

# `compress method must be defined when leaf type is different from input type`

## What it means

An SP-GiST operator class defined a leaf storage type different from the input type but did not provide a `compress` support function. SP-GiST needs the compress function to convert input values into the leaf representation.

## When it happens

It happens when creating an SP-GiST operator class whose `STORAGE` (leaf) type differs from the indexed column type and no compress method is supplied.

## How to fix

Add a `compress` support function to the operator class, or make the leaf storage type match the input type so no conversion is needed.

## Example

*Illustrative* — an SP-GiST opclass missing a compress method.

```text
ERROR:  compress method must be defined when leaf type is different from input type
```

## Related

- [compressed array is too big](./compressed-array-is-too-big-recreate-index-using-gist-intbig-ops-opclass-instead.md)
- [composite data types are not binary-compatible](./composite-data-types-are-not-binary-compatible.md)
