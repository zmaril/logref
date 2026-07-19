---
message: "positions array too long"
slug: positions-array-too-long
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/tsearch/to_tsany.c:217"
  - "postgres/src/backend/utils/adt/tsvector.c:292"
reproduced: false
---

# `positions array too long`

## What it means

A full-text-search operation was given a positions array longer than the format permits. Position lists attached to lexemes in a `tsvector` have a bounded length, and this input exceeds it.

## When it happens

It arises when constructing or manipulating `tsvector` values whose per-lexeme position lists grow beyond the allowed maximum — typically from an extremely long document where a single lexeme accumulates too many positions.

## How to fix

Reduce the number of positions per lexeme, for example by trimming or splitting very large documents before building the `tsvector`, or by stripping positions with `strip()` when positional information is not needed.

## Example

*Illustrative* — a tsvector with an over-long position list.

```text
ERROR:  positions array too long
```

## Related

- [string is too long for tsvector (%d bytes, max %d bytes)](./string-is-too-long-for-tsvector-bytes-max-bytes.md)
- [unexpected end of flag array](./unexpected-end-of-flag-array.md)
