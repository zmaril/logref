---
message: "argument types %s and %s cannot be matched"
slug: argument-types-and-cannot-be-matched
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:1532"
reproduced: false
---

# `argument types %s and %s cannot be matched`

## What it means

Two argument expressions had types that could not be reconciled to a common type, so the operation joining them (a comparison, a `CASE`, a `UNION`, or similar) cannot proceed.

## When it happens

It occurs when constructs that require their branches or operands to share a type are given incompatible types with no implicit resolution — for example mismatched `CASE` result types or `UNION` column types.

## How to fix

Cast the arguments to a common type explicitly so they match. Identify which two types are incompatible from the message and add casts (for example `::text` or `::numeric`) so both sides agree.

## Example

*Illustrative* — CASE branches of incompatible types.

```sql
SELECT CASE WHEN b THEN 1 ELSE 'x' END FROM t;  -- ERROR:  argument types integer and text cannot be matched
```

## Related

- [arguments of anycompatible family cannot be cast to a common type](./arguments-of-anycompatible-family-cannot-be-cast-to-a-common-type.md)
- [array data types are not binary-compatible](./array-data-types-are-not-binary-compatible.md)
