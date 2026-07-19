---
message: "unexpected typLen: %d"
slug: unexpected-typlen
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/datum.c:342"
  - "postgres/src/backend/utils/adt/datum.c:408"
reproduced: false
---

# `unexpected typLen: %d`

## What it means

Internal error. Code handling a data type's stored length found a `typlen` value that is neither a valid fixed length nor one of the special markers for variable-length or by-reference types.

## When it happens

It fires where type metadata is used to lay out or copy a datum and the length is outside the defined set. A correctly defined type does not produce it.

## How to fix

This is an internal guard over type metadata. A custom type declared with an invalid length, or a corrupt `pg_type` row, can provoke it; verify the type definition and report a reproducible case.

## Example

*Illustrative* — an invalid stored type length.

```text
ERROR:  unexpected typLen: 3
```

## Related

- [unsupported byval length: %d](./unsupported-byval-length.md)
- [unsupported integer size %d](./unsupported-integer-size.md)
