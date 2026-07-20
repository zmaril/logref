---
message: "unsupported byval length: %d"
slug: unsupported-byval-length
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/include/access/tupmacs.h:123"
  - "postgres/src/include/access/tupmacs.h:474"
reproduced: false
---

# `unsupported byval length: %d`

## What it means

Internal error. Code copying a pass-by-value datum met a length that is not one of the sizes the platform can pass by value (typically 1, 2, 4, or 8 bytes).

## When it happens

It fires where a by-value type's length is used to move a datum and the length is outside the supported set. A correctly defined type does not produce it.

## How to fix

This is an internal guard over type metadata. A custom type declared pass-by-value with an unsupported length can provoke it; verify the type definition and report a reproducible case.

## Example

*Illustrative* — an invalid by-value length.

```text
ERROR:  unsupported byval length: 3
```

## Related

- [unexpected typLen: %d](./unexpected-typlen.md)
- [unsupported integer size %d](./unsupported-integer-size.md)
