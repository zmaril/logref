---
message: "index %d out of valid range, 0..%d"
slug: index-out-of-valid-range-0
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
call_sites:
  - "postgres/src/backend/utils/adt/bytea.c:649"
  - "postgres/src/backend/utils/adt/bytea.c:716"
reproduced: false
---

# `index %d out of valid range, 0..%d`

## What it means

An array or collection was accessed with a subscript outside the allowed range. The message shows the offending index and the valid upper bound; the lower bound is zero.

## When it happens

It arises from functions that take a zero-based position argument — for example bit-string or byte-position helpers, or extension functions — when the caller passes a position below zero or at/above the length.

## How to fix

Pass a position within `0..N`, where `N` is the reported bound. Validate the index against the object's length before calling, and remember these positions are zero-based, so the last valid value is one less than the length.

## Example

*Illustrative* — a position past the end.

```text
ERROR:  index 9 out of valid range, 0..4
```

## Related

- [number is out of range](./number-is-out-of-range.md)
- [invalid line number](./invalid-line-number.md)
