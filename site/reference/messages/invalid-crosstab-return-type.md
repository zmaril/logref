---
message: "invalid crosstab return type"
slug: invalid-crosstab-return-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/contrib/tablefunc/tablefunc.c:673"
  - "postgres/contrib/tablefunc/tablefunc.c:860"
  - "postgres/contrib/tablefunc/tablefunc.c:1531"
  - "postgres/contrib/tablefunc/tablefunc.c:1544"
  - "postgres/contrib/tablefunc/tablefunc.c:1565"
reproduced: false
---

# `invalid crosstab return type`

## What it means

A `tablefunc` crosstab function was declared with a result row type that does not fit what crosstab produces. Crosstab requires the function's output columns to match the row-name column plus one column per category value; a definition that does not is rejected.

## When it happens

Calling `crosstab(...)` with a `AS (...)` column definition or a return type whose column count/types do not correspond to the row-name column followed by the expected category columns.

## How to fix

Declare the return columns to match: a first column for the row name, then one column per category in the pivot, with compatible types. For the two-argument `crosstab(text, text)` form, make sure the category query yields exactly the categories your column list expects.

## Example

*Illustrative* — a crosstab result type that does not line up.

```sql
SELECT * FROM crosstab('...') AS ct(row_name text, a int);
```

## Related

- [cannot compare record types with different numbers of columns](./cannot-compare-record-types-with-different-numbers-of-columns.md)
- [relation does not have a composite type](./relation-does-not-have-a-composite-type.md)
