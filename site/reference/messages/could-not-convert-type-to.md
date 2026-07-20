---
message: "%s could not convert type %s to %s"
slug: could-not-convert-type-to
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CANNOT_COERCE
    code: "42846"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:1583"
reproduced: false
---

# `%s could not convert type %s to %s`

## What it means

A value of one data type could not be cast to another during query analysis. The leading `%s` names the context, and the two types that could not be reconciled are shown. No cast path exists between them.

## When it happens

It happens when a query, function call, or assignment requires an implicit conversion that PostgreSQL has no cast for — for example passing an argument of the wrong type to a construct that expects a specific one.

## How to fix

Add an explicit cast (`value::target_type`) or supply a value of the expected type. If a custom type is involved, define the needed cast with `CREATE CAST`. Check the context named at the start of the message to see which value is at fault.

## Example

*Illustrative* — no cast between the two types.

```text
ERROR:  ... could not convert type integer to xml
```

## Related

- [could not coerce FOR PORTION OF target from to](./could-not-coerce-for-portion-of-target-from-to.md)
- [could not convert value of type to jsonpath](./could-not-convert-value-of-type-to-jsonpath.md)
