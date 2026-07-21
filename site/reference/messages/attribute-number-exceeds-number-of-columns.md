---
message: "attribute number %d exceeds number of columns %d"
slug: attribute-number-exceeds-number-of-columns
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execExprInterp.c:2413"
  - "postgres/src/backend/executor/execExprInterp.c:3775"
  - "postgres/src/backend/executor/execExprInterp.c:3821"
reproduced: false
---

# `attribute number %d exceeds number of columns %d`

## What it means

Internal error. Expression-evaluation code referenced a column by attribute number larger than the tuple's column count. The placeholders are the requested attribute number and the actual column count. Attribute numbers are assigned from the tuple descriptor, so one out of range is a consistency check.

## When it happens

It does not arise from ordinary SQL, which resolves columns by name against the descriptor. Reaching this internal form points to a mismatch between a cached plan or expression and the current tuple shape — often after concurrent DDL — or a bug in code building tuples directly.

## How to fix

If it followed a concurrent `ALTER TABLE` that changed the column set, retry so plans are re-planned against the new shape. If it recurs on a stable schema, capture the statement and report it; a custom access method or extension manipulating tuples is a likely suspect.

## Example

*Illustrative* — emitted internally during expression evaluation.

```text
ERROR:  attribute number 5 exceeds number of columns 3
```

## Related

- [tables can have at most columns](./tables-can-have-at-most-columns.md)
- [has no attribute](./has-no-attribute.md)
