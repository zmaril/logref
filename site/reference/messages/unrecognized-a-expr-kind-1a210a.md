---
message: "unrecognized A_Expr kind: %d"
slug: unrecognized-a-expr-kind-1a210a
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:218"
  - "postgres/src/backend/parser/parse_expr.c:1395"
reproduced: false
---

# `unrecognized A_Expr kind: %d`

## What it means

Internal error. Parse-analysis code switching on an `A_Expr` kind (the raw-parse node for many operator and comparison expressions) found a kind it does not handle.

## When it happens

It fires during transformation of a raw expression tree when the expression node carries an unexpected kind. Well-formed SQL does not produce it.

## How to fix

This is an internal consistency guard. If a real expression triggers it, capture the statement and report it as a reproducible parser bug.

## Example

*Illustrative* — an unhandled A_Expr kind.

```text
ERROR:  unrecognized A_Expr kind: 13
```

## Related

- [unrecognized node type in jointree: %d](./unrecognized-node-type-in-jointree.md)
- [unrecognized testexpr type: %d](./unrecognized-testexpr-type.md)
