---
message: "could not find element type for data type %s"
slug: could-not-find-element-type-for-data-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:2139"
reproduced: false
---

# `could not find element type for data type %s`

## What it means

An expression treated a value as an array (for example subscripting it) but the value's type is not an array type, so it has no element type. The `%s` names the type.

## When it happens

It happens when array subscripting or a similar array operation is applied to a non-array value, so PostgreSQL cannot determine the element type it would produce.

## How to fix

Apply array operations only to array values. Check the expression being subscripted — cast it to an array type if it should be one, or correct the logic if a scalar was used where an array was intended.

## Example

*Illustrative* — subscripting a non-array value.

```sql
SELECT (42)[1];
-- ERROR:  could not find element type for data type integer
```

## Related

- [could not find array type for datatype](./could-not-find-array-type-for-datatype.md)
- [could not determine polymorphic type because input has type](./could-not-determine-polymorphic-type-because-input-has-type-ede818.md)
