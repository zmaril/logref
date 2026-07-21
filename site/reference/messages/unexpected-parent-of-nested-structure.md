---
message: "unexpected parent of nested structure"
slug: unexpected-parent-of-nested-structure
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/jsonb.c:446"
  - "postgres/src/backend/utils/adt/jsonb.c:887"
reproduced: false
---

# `unexpected parent of nested structure`

## What it means

Internal error. While building or iterating a nested `jsonb`/container structure, the code reached a state where the parent frame was not one of the container kinds it expects.

## When it happens

It fires from container construction routines when the stack of open objects and arrays is inconsistent. Ordinary values do not produce it.

## How to fix

This is an internal guard. If a real expression provokes it, capture the input and the function producing the value and report it as a reproducible bug.

## Example

*Illustrative* — an inconsistent container parent.

```text
ERROR:  unexpected parent of nested structure
```

## Related

- [unexpected jsonb value type: %d](./unexpected-jsonb-value-type-92f4ff.md)
- [unrecognized jsonb type: %d](./unrecognized-jsonb-type.md)
