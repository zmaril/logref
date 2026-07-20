---
message: "could not determine interpretation of row comparison operator %s"
slug: could-not-determine-interpretation-of-row-comparison-operator
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:2978"
  - "postgres/src/backend/parser/parse_expr.c:3019"
reproduced: false
---

# `could not determine interpretation of row comparison operator %s`

## What it means

A row-value comparison used an operator that Postgres cannot interpret consistently across the row's columns. The placeholder is the operator. Row comparisons require the operator to have a coherent meaning (via a btree operator class) for every column pair.

## When it happens

Comparing row constructors with a custom or non-standard operator — `(a, b) OP (c, d)` — where the operator lacks the operator-class support needed to define a row-level ordering or equality.

## How to fix

Use a standard comparison operator (`=`, `<`, `>`, and so on) backed by a btree operator class for row comparisons, or compare the columns individually with explicit logic. Row-comparison operators must map to a consistent per-column interpretation.

## Example

*Illustrative* — an uninterpretable row-comparison operator.

```text
ERROR:  could not determine interpretation of row comparison operator ~~
```

## Related

- [could not determine data type of parameter](./could-not-determine-data-type-of-parameter.md)
- [could not find compatible hash operator for operator](./could-not-find-compatible-hash-operator-for-operator.md)
