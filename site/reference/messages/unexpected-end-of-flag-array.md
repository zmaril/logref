---
message: "unexpected end of flag array"
slug: unexpected-end-of-flag-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:5615"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:5620"
reproduced: false
---

# `unexpected end of flag array`

## What it means

A full-text-search dictionary or configuration parsed a flag array that ended before it was complete. The input defining flags (for example in an ispell/affix-style resource) is truncated or malformed.

## When it happens

It arises when building or using a text-search dictionary whose flag data is incomplete — a corrupted or badly formatted dictionary/affix file, or malformed input to a function expecting a flag array.

## How to fix

Check the text-search dictionary files or the input producing the flag array for truncation or format errors, and restore a complete, well-formed version. Reload the dictionary after fixing the source data.

## Example

*Illustrative* — a truncated flag array.

```text
ERROR:  unexpected end of flag array
```

## Related

- [positions array too long](./positions-array-too-long.md)
- [unexpected end of line or lexeme](./unexpected-end-of-line-or-lexeme.md)
