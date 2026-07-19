---
message: "bogus upper boundary types %d %d"
slug: bogus-upper-boundary-types
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/seg/seg.c:850"
reproduced: false
---

# `bogus upper boundary types %d %d`

## What it means

Range-type logic encountered a combination of upper-boundary kind values it does not expect. The placeholders are the two boundary type codes. Range boundaries are inclusive, exclusive, or infinite, and this pairing is unhandled. It is an internal guard.

## When it happens

It is a can't-happen check in range-type handling that would surface from a corrupted range value or a bug, not from normal range use.

## How to fix

This is not caused by ordinary range operations. If it appears, capture the range value or expression and report it as a possible bug, including any extension that builds ranges directly.

## Example

*Illustrative* — an unexpected upper-boundary pairing.

```text
ERROR:  bogus upper boundary types 3 4
```

## Related

- [bogus lower boundary types](./bogus-lower-boundary-types.md)
- [bogus rowcompare index qualification](./bogus-rowcompare-index-qualification.md)
