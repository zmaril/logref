---
message: "NaN or Infinity is not allowed for jsonpath item method .%s()"
slug: nan-or-infinity-is-not-allowed-for-jsonpath-item-method
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NON_NUMERIC_SQL_JSON_ITEM
    code: "22036"
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1206"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1232"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1445"
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1477"
reproduced: false
---

# `NaN or Infinity is not allowed for jsonpath item method .%s()`

## What it means

A `jsonpath` item method that produces a numeric result (such as `.double()`, `.number()`, or an arithmetic method) evaluated to `NaN` or an infinity, which SQL/JSON does not permit as a numeric item value. The placeholder names the method. JSON has no representation for `NaN`/`Infinity`, so a path expression that would yield one is an error.

## When it happens

Running a `jsonpath` query whose numeric method is applied to input that overflows to infinity or is not a finite number — for example converting an out-of-range string to a double, or dividing by zero inside the path.

## How to fix

Adjust the path so it never produces a non-finite number: guard with a filter (`? (@ > 0)`), avoid dividing by zero, or convert values that may be out of range in SQL after extraction rather than inside the path. If a missing or non-finite result is acceptable, use the lax mode and `ON ERROR` behavior of the surrounding SQL/JSON function to absorb it.

## Example

*Illustrative* — a jsonpath method yielding infinity.

```sql
SELECT jsonb_path_query('1e400', '$.double()');
```

## Related

- [cannot call on an array](./cannot-call-on-an-array.md)
- [argument of jsonpath item method is invalid for type](./argument-of-jsonpath-item-method-is-invalid-for-type.md)
