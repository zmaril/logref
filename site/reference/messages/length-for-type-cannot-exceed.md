---
message: "length for type %s cannot exceed %d"
slug: length-for-type-cannot-exceed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/varbit.c:113"
  - "postgres/src/backend/utils/adt/varchar.c:55"
reproduced: false
---

# `length for type %s cannot exceed %d`

## What it means

A type modifier (length) is larger than the maximum the type allows. The placeholders name the type and the maximum length. For example `varchar` and `char` cap their length at 10485760.

## When it happens

It arises from a column or cast declaration like `varchar(n)`, `char(n)`, `bit(n)`, or `numeric` precision where `n` exceeds the type's allowed maximum.

## How to fix

Reduce the length to at most the type's maximum. If you need to store larger values, use an unbounded type — `text` instead of `varchar(n)`, or `numeric` without a precision cap that fits your data.

## Example

*Illustrative* — a varchar length beyond the maximum.

```sql
CREATE TABLE t (c varchar(20000000));  -- exceeds the type maximum
```

## Related

- [length for type must be at least 1](./length-for-type-must-be-at-least-1.md)
- [number of columns exceeds limit](./number-of-columns-exceeds-limit.md)
