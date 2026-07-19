---
message: "could not identify an ordering operator for type %s"
slug: could-not-identify-an-ordering-operator-for-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/parser/parse_agg.c:217"
  - "postgres/src/backend/parser/parse_oper.c:216"
reproduced: false
---

# `could not identify an ordering operator for type %s`

## What it means

An operation needed to order values of a type — for `ORDER BY`, `DISTINCT`, a sort-based aggregate, or a merge join — but the type has no default `<` ordering operator registered.

## When it happens

Sorting, grouping, or comparing values of a type that lacks a default b-tree operator class, such as a bare `xml` or a user-defined type with no comparison operators.

## How to fix

Cast the values to a comparable type, or provide an explicit operator (for example `ORDER BY x::text`). For a custom type, define a b-tree operator class so its values can be ordered.

## Example

*Illustrative* — ordering by an xml column.

```text
ERROR:  could not identify an ordering operator for type xml
```

## Related

- [could not identify an extended hash function for type](./could-not-identify-an-extended-hash-function-for-type.md)
- [could not implement GROUP BY](./could-not-implement-group-by.md)
