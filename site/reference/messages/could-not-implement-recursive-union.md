---
message: "could not implement recursive UNION"
slug: could-not-implement-recursive-union
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/optimizer/prep/prepunion.c:446"
reproduced: false
---

# `could not implement recursive UNION`

## What it means

The planner could not build a plan for a recursive `UNION` because a column's type supports neither sorting nor hashing. The recursive term must detect already-seen rows, which needs a way to compare each column.

## When it happens

It fires while planning a recursive `WITH` query that uses `UNION` (which removes duplicates) over a column whose type has no b-tree or hash operator class.

## How to fix

Use `UNION ALL` instead of `UNION` if duplicate elimination is not required, or cast the offending column to a groupable type. For a custom type, add a b-tree or hash operator class so it can be de-duplicated in the recursion.

## Example

*Illustrative* — a recursive UNION over an ungroupable column type.

```text
ERROR:  could not implement recursive UNION
DETAIL:  All column datatypes must be hashable.
```

## Related

- [could not implement](./could-not-implement.md)
- [could not identify an intersect function for type](./could-not-identify-an-intersect-function-for-type.md)
