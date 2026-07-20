---
message: "expected 2-element int8 array"
slug: expected-2-element-int8-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/numeric.c:6441"
  - "postgres/src/backend/utils/adt/numeric.c:6469"
  - "postgres/src/backend/utils/adt/numeric.c:6494"
  - "postgres/src/backend/utils/adt/numeric.c:6498"
  - "postgres/src/backend/utils/adt/numeric.c:6528"
  - "postgres/src/backend/utils/adt/numeric.c:6556"
  - "postgres/src/backend/utils/adt/numeric.c:6575"
  - "postgres/src/backend/utils/adt/numeric.c:6600"
reproduced: false
---

# `expected 2-element int8 array`

## What it means

Internal error. Code that exchanges a pair of 64-bit integers as a 2-element `int8[]` (used in some numeric/aggregate internal interfaces) received an array that did not have exactly two elements. It signals a mismatch in an internal aggregate or support-function protocol.

## When it happens

A bug in a custom aggregate or extension that implements a numeric transition/combine function with the wrong array shape, or corruption of the internal state array. Ordinary aggregate use does not trigger it.

## How to fix

If a custom aggregate or extension is involved, suspect its transition/combine functions — they must produce the exact 2-element `int8[]` the interface expects. Report reproducible cases to the extension author. It is a programming error in the aggregate implementation, not a data issue.

## Example

*Illustrative* — a malformed internal aggregate state.

```text
ERROR:  expected 2-element int8 array
```

## Related

- [aggregate function called in non-aggregate context](./aggregate-function-called-in-non-aggregate-context.md)
- [array must be one-dimensional](./array-must-be-one-dimensional.md)
