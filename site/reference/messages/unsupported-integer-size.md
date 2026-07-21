---
message: "unsupported integer size %d"
slug: unsupported-integer-size
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/pqformat.c:436"
  - "postgres/src/include/libpq/pqformat.h:185"
reproduced: false
---

# `unsupported integer size %d`

## What it means

Internal error. A routine handling integers of a caller-supplied width met a size it does not support (a width other than the standard 2-, 4-, or 8-byte cases).

## When it happens

It fires in low-level encoding/decoding or binary send/receive paths when an integer width is outside the supported set. Ordinary SQL does not reach it.

## How to fix

This is an internal guard. If it appears from a query or a data-type function, capture the call and the types involved and report it as a reproducible bug.

## Example

*Illustrative* — an unsupported integer width.

```text
ERROR:  unsupported integer size 3
```

## Related

- [unsupported byval length: %d](./unsupported-byval-length.md)
- [unexpected typLen: %d](./unexpected-typlen.md)
