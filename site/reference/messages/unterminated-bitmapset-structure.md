---
message: "unterminated Bitmapset structure"
slug: unterminated-bitmapset-structure
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/read.c:433"
  - "postgres/src/backend/nodes/readfuncs.c:232"
reproduced: false
---

# `unterminated Bitmapset structure`

## What it means

Internal error. The node reader parsing a serialized `Bitmapset` reached the end of input before the structure's closing token.

## When it happens

It fires when reading a stored or transmitted plan/node tree whose `Bitmapset` serialization is truncated or malformed. Normal operation does not produce it.

## How to fix

This is an internal guard over node serialization. If it appears when reading a stored plan or a parallel-worker payload, capture the operation and report it as a reproducible bug.

## Example

*Illustrative* — a truncated Bitmapset.

```text
ERROR:  unterminated Bitmapset structure
```

## Related

- [unexpected node type in name list: %d](./unexpected-node-type-in-name-list.md)
- [wrong number of tlist entries](./wrong-number-of-tlist-entries.md)
