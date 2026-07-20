---
message: "cannot retrieve a system column in this context"
slug: cannot-retrieve-a-system-column-in-this-context
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/executor/execTuples.c:145"
  - "postgres/src/backend/executor/execTuples.c:367"
  - "postgres/src/backend/executor/execTuples.c:562"
  - "postgres/src/backend/executor/execTuples.c:772"
reproduced: false
---

# `cannot retrieve a system column in this context`

## What it means

A query referenced a system column (like `ctid`, `xmin`, `tableoid`) in a place where it is not available. The placeholder-free text covers contexts — certain joins, function scans, or virtual tuples — that have no underlying heap tuple to supply system columns.

## When it happens

Selecting a system column from a source that does not carry one — for example the output of some set-returning functions, `VALUES` lists, certain views, or the non-preserved side of an outer join where the row is synthesized.

## How to fix

Only reference system columns on real table scans that provide them. Redesign the query to obtain the needed value another way (add a real column, use a primary key instead of `ctid`), or restructure so the system column comes directly from a base table scan.

## Example

*Illustrative* — ctid from a context that lacks it.

```sql
SELECT ctid FROM generate_series(1, 3);
```

## Related

- [cannot move system relation](./cannot-move-system-relation.md)
- [record has no field](./record-has-no-field.md)
