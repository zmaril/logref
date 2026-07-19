---
message: "invalid jsonpath item type for .split_part()"
slug: invalid-jsonpath-item-type-for-split-part
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:3021"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:3027"
reproduced: false
---

# `invalid jsonpath item type for .split_part()`

## What it means

Internal error. Evaluating a jsonpath `.split_part()` method, the executor found a jsonpath item node of a type it does not expect at that position. It is a consistency guard in the jsonpath evaluator.

## When it happens

It fires while executing a jsonpath expression using `.split_part()` whose internal node structure is malformed. A well-formed jsonpath does not reach it; it points to an internal bug.

## How to fix

This is a can't-happen guard. Capture the exact jsonpath expression and the input, and report a reproducible case. As a workaround, rewrite the extraction without the failing jsonpath method.

## Example

*Illustrative* — a malformed jsonpath split_part node.

```text
ERROR:  invalid jsonpath item type for .split_part()
```

## Related

- [jsonpath item method can only be applied to a string](./jsonpath-item-method-can-only-be-applied-to-a-string.md)
- [invalid JsonFuncExpr op](./invalid-jsonfuncexpr-op.md)
