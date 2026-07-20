---
message: "cannot store a toast pointer inside a range"
slug: cannot-store-a-toast-pointer-inside-a-range
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/rangetypes.c:2966"
reproduced: false
---

# `cannot store a toast pointer inside a range`

## What it means

An internal guard fired: the range type code tried to store a value that was still a TOAST pointer inside a range's bound. Range bounds must be fully detoasted before they are packed, so this state should not occur in normal execution.

## When it happens

It is reached from range serialization when constructing a range value. It reflects a coding issue in a range-handling path rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the query and any custom range type or extension in use, then report it. It indicates a bug in the code that built the range.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  cannot store a toast pointer inside a range
```

## Related

- [cannot subtract inet values of different sizes](./cannot-subtract-inet-values-of-different-sizes.md)
- [cannot translate to multiple leaf relids](./cannot-translate-to-multiple-leaf-relids.md)
