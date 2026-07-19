---
message: "cannot compare record types with different numbers of columns"
slug: cannot-compare-record-types-with-different-numbers-of-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/adt/rowtypes.c:1038"
  - "postgres/src/backend/utils/adt/rowtypes.c:1263"
  - "postgres/src/backend/utils/adt/rowtypes.c:1566"
  - "postgres/src/backend/utils/adt/rowtypes.c:1751"
reproduced: false
---

# `cannot compare record types with different numbers of columns`

## What it means

Two record (composite) values with different column counts were compared. Record comparison pairs columns positionally, so both sides must have the same number of columns.

## When it happens

Comparing two `ROW(...)`/`record` values (with `=`, ordering, `DISTINCT`, or in a set operation) whose numbers of fields differ.

## How to fix

Compare records with the same number of columns. Trim or extend one side so the shapes match, or compare only the specific fields you intend rather than whole rows of unequal width.

## Example

*Illustrative* — comparing rows of different widths.

```sql
SELECT ROW(1, 2) = ROW(1, 2, 3);
```

## Related

- [cannot compare dissimilar column types and at record column](./cannot-compare-dissimilar-column-types-and-at-record-column.md)
- [invalid crosstab return type](./invalid-crosstab-return-type.md)
