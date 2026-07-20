---
message: "number of aliases does not match number of columns"
slug: number-of-aliases-does-not-match-number-of-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/fmgr/funcapi.c:1932"
  - "postgres/src/backend/utils/fmgr/funcapi.c:1964"
reproduced: false
---

# `number of aliases does not match number of columns`

## What it means

A column alias list provided for a relation or function has a different number of names than the relation produces columns. Each output column needs at most one alias, and the counts must line up.

## When it happens

It arises in `FROM func() AS t(col1, col2, ...)`, a subquery/`VALUES` alias list, or a `JOIN` column alias where the number of aliases differs from the number of output columns.

## How to fix

Provide exactly as many aliases as the relation has columns (or fewer only where partial aliasing is allowed, matching from the left). Count the output columns — for a record-returning function, its declared columns — and align the alias list.

## Example

*Illustrative* — too few aliases for the output columns.

```sql
SELECT * FROM generate_series(1,3) AS g(a, b);  -- one column, two aliases
```

## Related

- [number of columns does not match number of values](./number-of-columns-does-not-match-number-of-values.md)
- [incorrect output types](./incorrect-output-types.md)
