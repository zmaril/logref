---
message: "cannot coerce %s to double"
slug: cannot-coerce-to-double
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:2082"
reproduced: false
---

# `cannot coerce %s to double`

## What it means

A jsonpath or SQL/JSON expression tried to interpret a value as a double-precision number when it cannot be converted to one. The placeholder is the value or item. The value's type or content does not map to a floating-point number here.

## When it happens

It occurs in SQL/JSON path evaluation when a numeric operation expects a double but receives a value that does not convert, such as a non-numeric string.

## How to fix

Supply numeric input where a double is required, or convert values with an explicit jsonpath method. Validate the JSON so numeric operations receive numbers.

## Example

*Illustrative* — a non-numeric value as double.

```text
ERROR:  cannot coerce "abc" to double
```

## Related

- [cannot coerce to int](./cannot-coerce-to-int.md)
- [cannot coerce to boolean](./cannot-coerce-to-boolean.md)
