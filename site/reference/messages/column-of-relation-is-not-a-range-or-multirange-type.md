---
message: "column \"%s\" of relation \"%s\" is not a range or multirange type"
slug: column-of-relation-is-not-a-range-or-multirange-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
call_sites:
  - "postgres/src/backend/parser/analyze.c:1420"
reproduced: false
---

# `column "%s" of relation "%s" is not a range or multirange type`

## What it means

A temporal or overlap-related feature required a column of range or multirange type, but the named column has a different type. The operation compares ranges, so the column must hold one.

## When it happens

It happens in temporal-key or `FOR PORTION OF` style processing when the period column is a plain scalar rather than a range or multirange.

## How to fix

Use a range or multirange column for the period, or convert the scalar period columns into a single range value first. Check the column referenced by the temporal clause.

## Example

*Illustrative* — a scalar column where a range is required.

```text
ERROR:  column "valid_at" of relation "t" is not a range or multirange type
```

## Related

- [column of relation is not a range type](./column-of-relation-is-not-a-range-type.md)
- [column in WITHOUT OVERLAPS is not a range or multirange type](./column-in-without-overlaps-is-not-a-range-or-multirange-type.md)
