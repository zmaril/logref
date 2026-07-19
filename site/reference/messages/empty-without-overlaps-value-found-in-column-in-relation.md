---
message: "empty WITHOUT OVERLAPS value found in column \"%s\" in relation \"%s\""
slug: empty-without-overlaps-value-found-in-column-in-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CHECK_VIOLATION
    code: "23514"
call_sites:
  - "postgres/src/backend/executor/execIndexing.c:1185"
reproduced: false
---

# `empty WITHOUT OVERLAPS value found in column "%s" in relation "%s"`

## What it means

An empty range or multirange value was stored in a column that participates in a `WITHOUT OVERLAPS` temporal constraint. The placeholders are the column and relation names. Such constraints require a non-empty period for each row.

## When it happens

It fires during `INSERT`/`UPDATE` on a table with a temporal `PRIMARY KEY`/`UNIQUE ... WITHOUT OVERLAPS` when the period column's value is an empty range.

## How to fix

Provide a non-empty range for the temporal column of each row. An empty range has no time span and cannot be checked for overlap, so give the period a real lower and upper bound.

## Example

*Illustrative* — an empty period in a temporal table.

```sql
INSERT INTO booking (room, during) VALUES (1, 'empty'::tsrange);
-- empty WITHOUT OVERLAPS value found in column "during" in relation "booking"
```

## Related

- [domain does not allow null values](./domain-does-not-allow-null-values.md)
- [each query must have the same number of columns](./each-query-must-have-the-same-number-of-columns.md)
