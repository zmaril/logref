---
message: "invalid JsonFuncExpr op %d"
slug: invalid-jsonfuncexpr-op
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:4444"
  - "postgres/src/backend/parser/parse_expr.c:4794"
reproduced: false
---

# `invalid JsonFuncExpr op %d`

## What it means

Internal error. A parsed SQL/JSON function-expression node carried an operation code the executor does not recognize. The placeholder is the numeric op. It is a consistency guard over `JsonFuncExpr` handling.

## When it happens

It fires when evaluating an SQL/JSON construct (`JSON_QUERY`, `JSON_VALUE`, `JSON_EXISTS`, and relatives) whose internal op field is out of range. Ordinary use does not surface it; it points to an internal bug or a plan mismatch across versions.

## How to fix

This is a can't-happen guard. If it appears after an upgrade with cached plans, reconnect to force replanning. Capture the SQL/JSON query and report a reproducible case.

## Example

*Illustrative* — an unrecognized SQL/JSON function op.

```text
ERROR:  invalid JsonFuncExpr op 9
```

## Related

- [invalid jsonpath item type for split_part](./invalid-jsonpath-item-type-for-split-part.md)
- [JSON path expression in JSON_VALUE must return single scalar item](./json-path-expression-in-json-value-must-return-single-scalar-item.md)
