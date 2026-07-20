---
message: "cannot coerce %s to int"
slug: cannot-coerce-to-int
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:2061"
reproduced: false
---

# `cannot coerce %s to int`

## What it means

A jsonpath or SQL/JSON expression tried to interpret a value as an integer when it cannot be converted to one. The placeholder is the value or item. The value's type or content does not map to an integer here.

## When it happens

It occurs in SQL/JSON path evaluation when an operation expects an integer — such as an array index — but receives a value that does not convert.

## How to fix

Provide integer input where an integer is required, or convert with an explicit jsonpath method. Check the path so integer context receives whole-number input.

## Example

*Illustrative* — a non-integer value as int.

```text
ERROR:  cannot coerce "1.5" to int
```

## Related

- [cannot coerce to double](./cannot-coerce-to-double.md)
- [cannot coerce to boolean](./cannot-coerce-to-boolean.md)
