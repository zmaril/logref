---
message: "bogus lower boundary types %d %d"
slug: bogus-lower-boundary-types
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/seg/seg.c:792"
reproduced: false
---

# `bogus lower boundary types %d %d`

## What it means

Range-type logic encountered a combination of lower-boundary kind values it does not expect. The placeholders are the two boundary type codes. Range boundaries are inclusive, exclusive, or infinite, and this pairing is not one the code handles. It is an internal guard.

## When it happens

It is a can't-happen check in range-type handling. It would surface from a corrupted range value or a bug, not from constructing ranges normally.

## How to fix

This is not caused by ordinary range operations. If it appears, capture the range value or expression involved and report it as a possible bug, including any extension that builds range values directly.

## Example

*Illustrative* — an unexpected lower-boundary pairing.

```text
ERROR:  bogus lower boundary types 3 4
```

## Related

- [bogus upper boundary types](./bogus-upper-boundary-types.md)
- [bogus rowcompare index qualification](./bogus-rowcompare-index-qualification.md)
