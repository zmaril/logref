---
message: "column \"%s\" of relation \"%s\" is not a range type"
slug: column-of-relation-is-not-a-range-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
call_sites:
  - "postgres/src/backend/parser/analyze.c:1441"
reproduced: false
---

# `column "%s" of relation "%s" is not a range type`

## What it means

A feature required a column of range type specifically, but the named column has another type. The column must be a range for the operation to proceed.

## When it happens

It happens in temporal or period processing that expects a range column and finds a scalar or multirange column instead.

## How to fix

Use a range-typed column for the period, or cast/rebuild the column as an appropriate range type. Verify which column the statement references.

## Example

*Illustrative* — a non-range column where a range is required.

```text
ERROR:  column "valid_at" of relation "t" is not a range type
```

## Related

- [column of relation is not a range or multirange type](./column-of-relation-is-not-a-range-or-multirange-type.md)
- [column in WITHOUT OVERLAPS is not a range or multirange type](./column-in-without-overlaps-is-not-a-range-or-multirange-type.md)
