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
reproduced: true
---

# `cannot compare record types with different numbers of columns`

## What it means

Two record (composite) values with different column counts were compared. Record comparison pairs columns positionally, so both sides must have the same number of columns.

## When it happens

Comparing two `ROW(...)`/`record` values (with `=`, ordering, `DISTINCT`, or in a set operation) whose numbers of fields differ.

## How to fix

Compare records with the same number of columns. Trim or extend one side so the shapes match, or compare only the specific fields you intend rather than whole rows of unequal width.

## Example

*Reproduced* — captured from `reproducers/scenarios/18_arrays_ranges_composite.sql`.

```sql
SELECT record_eq(ROW(1), ROW(1,2));
```

Produces:

```text
ERROR:  cannot compare record types with different numbers of columns
```

## Related

- [cannot compare dissimilar column types and at record column](./cannot-compare-dissimilar-column-types-and-at-record-column.md)
- [invalid crosstab return type](./invalid-crosstab-return-type.md)
