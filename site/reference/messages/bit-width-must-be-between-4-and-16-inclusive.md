---
message: "bit width must be between 4 and 16 inclusive"
slug: bit-width-must-be-between-4-and-16-inclusive
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/lib/hyperloglog.c:71"
reproduced: false
---

# `bit width must be between 4 and 16 inclusive`

## What it means

A function that builds a bit-partitioned structure was given a bit-width parameter outside the range four through sixteen. The width controls how many bits index each level, and it must stay within those bounds.

## When it happens

It comes from a routine that takes an explicit bit-width argument, and it fires when the caller passes a value below four or above sixteen.

## How to fix

Pass a bit width in the inclusive range four to sixteen. Consult the documentation for the specific function to choose a width appropriate to the data size.

## Example

*Illustrative* — an out-of-range bit width.

```text
ERROR:  bit width must be between 4 and 16 inclusive
```

## Related

- [bit string length exceeds the maximum allowed](./bit-string-length-exceeds-the-maximum-allowed.md)
- [block size for slab is too small for byte chunks](./block-size-for-slab-is-too-small-for-byte-chunks.md)
