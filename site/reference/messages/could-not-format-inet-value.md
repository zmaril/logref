---
message: "could not format inet value: %m"
slug: could-not-format-inet-value
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_BINARY_REPRESENTATION
    code: "22P03"
call_sites:
  - "postgres/src/backend/utils/adt/network.c:148"
  - "postgres/src/backend/utils/adt/network.c:1115"
  - "postgres/src/backend/utils/adt/network.c:1165"
reproduced: false
---

# `could not format inet value: %m`

## What it means

The server could not convert an `inet`/`cidr` value to its text form. The placeholder is the OS error from the underlying address-formatting call. Since output formatting of a valid network value should not fail, this points to a corrupted stored value or an environment-level failure in the address routines.

## When it happens

Formatting an `inet`/`cidr` where the stored bytes are invalid (corruption) or the OS address-conversion routine returned an error. It is not produced by ordinary, valid network values.

## How to fix

Read the appended OS error. If a specific row reproduces it, the stored value is likely corrupt — identify and repair or restore that row. Check storage health if corruption is suspected. Report reproducible cases that are not explained by damaged data.

## Example

*Illustrative* — a network value that would not format.

```text
ERROR:  could not format inet value: ...
```

## Related

- [could not find tuple for rule](./could-not-find-tuple-for-rule.md)
- [corrupted line pointer offset size](./corrupted-line-pointer-offset-size-bdc6c1.md)
