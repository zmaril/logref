---
message: "cannot compare dissimilar column types %s and %s at record column %d"
slug: cannot-compare-dissimilar-column-types-and-at-record-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/adt/rowtypes.c:947"
  - "postgres/src/backend/utils/adt/rowtypes.c:1193"
  - "postgres/src/backend/utils/adt/rowtypes.c:1469"
  - "postgres/src/backend/utils/adt/rowtypes.c:1715"
reproduced: false
---

# `cannot compare dissimilar column types %s and %s at record column %d`

## What it means

Two record (composite) values were compared and a corresponding column pair has incompatible types. The placeholders are the two column types and the column position. Record comparison walks columns left to right and requires each pair to be comparable.

## When it happens

Comparing two `record`/`ROW(...)` values (with `=`, `<`, ordering, `DISTINCT`) whose columns at some position have types that have no comparison — for example comparing a row with an `int` third column against a row with a `text` third column.

## How to fix

Make the compared rows structurally compatible: the columns at each position must have comparable types. Cast the differing column so both rows agree at that position, or compare the specific fields you care about instead of whole rows.

## Example

*Illustrative* — comparing rows with a mismatched column.

```sql
SELECT ROW(1, 'a', 3) = ROW(1, 'a', 'x');
```

## Related

- [cannot compare record types with different numbers of columns](./cannot-compare-record-types-with-different-numbers-of-columns.md)
- [argument declared is not consistent with argument declared](./argument-declared-is-not-consistent-with-argument-declared.md)
