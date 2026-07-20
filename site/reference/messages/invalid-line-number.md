---
message: "invalid line number: %s"
slug: invalid-line-number
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:1390"
  - "postgres/src/bin/psql/command.c:6446"
reproduced: false
---

# `invalid line number: %s`

## What it means

A function that takes a line/tuple pointer position was given an out-of-range value. The placeholder is the offending line number as text. Line (item) numbers on a heap page start at 1.

## When it happens

It arises from tuple-location functions such as `tid` inspection or `pageinspect` helpers when the given line pointer index is zero, negative, or beyond the number of item pointers on the page.

## How to fix

Pass a line number within the valid range for the page (1 up to the page's item count). If you derived it from a `ctid`, remember its two parts are `(block, line)` with line starting at 1. Validate the value before calling.

## Example

*Illustrative* — a line pointer index out of range.

```text
ERROR:  invalid line number: 0
```

## Related

- [invalid column number](./invalid-column-number.md)
- [index out of valid range 0](./index-out-of-valid-range-0.md)
