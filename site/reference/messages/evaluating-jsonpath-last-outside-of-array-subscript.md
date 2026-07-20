---
message: "evaluating jsonpath LAST outside of array subscript"
slug: evaluating-jsonpath-last-outside-of-array-subscript
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1278"
reproduced: false
---

# `evaluating jsonpath LAST outside of array subscript`

## What it means

An internal guard in the jsonpath executor. The `last` keyword is only meaningful inside an array subscript, where it stands for the last index; this fires if it is evaluated in a context where no subscript is active.

## When it happens

It fires while running a jsonpath expression (through `jsonb_path_query` and related functions) if `last` reaches evaluation outside an array-subscript position. The parser normally rejects such uses, so reaching the executor is unexpected.

## How to fix

In your own jsonpath, only use `last` inside a subscript, as in `$[last]` or `$[1 to last]`. If you see this from ordinary, syntactically valid jsonpath, capture the exact path and input and report it as a possible bug, since the check guards an internal invariant.

## Example

*Illustrative* — `last` belongs inside a subscript.

```sql
SELECT jsonb_path_query('[10,20,30]', '$[last]');  -- correct usage
```

## Related

- [expression not found in statistics object](./expression-not-found-in-statistics-object.md)
- [expected element float8 array](./expected-element-float8-array.md)
