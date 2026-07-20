---
message: "cannot compare rows of zero length"
slug: cannot-compare-rows-of-zero-length
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:2887"
reproduced: false
---

# `cannot compare rows of zero length`

## What it means

An internal row-comparison routine was given a composite value with no columns. Comparing rows requires at least one field to compare, so a zero-length row is a consistency error in the code path that built it.

## When it happens

It is a can't-happen guard reached during row comparison. It would only surface from a bug that produced an empty composite value.

## How to fix

There is no user-level fix. If it appears, capture the query and any custom types or extensions involved and report it, since ordinary rows always have columns.

## Example

*Illustrative* — comparing an empty row.

```text
ERROR:  cannot compare rows of zero length
```

## Related

- [cannot commute non-binary-operator clause](./cannot-commute-non-binary-operator-clause.md)
- [cannot deconstruct a scalar](./cannot-deconstruct-a-scalar.md)
