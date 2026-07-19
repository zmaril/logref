---
message: "constraint using WITHOUT OVERLAPS needs at least two columns"
slug: constraint-using-without-overlaps-needs-at-least-two-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:2836"
reproduced: false
---

# `constraint using WITHOUT OVERLAPS needs at least two columns`

## What it means

A `WITHOUT OVERLAPS` constraint was defined with only the overlap column and no scalar key columns. A temporal constraint needs at least one ordinary key column plus the range column, so two columns minimum.

## When it happens

It happens on `CREATE TABLE`/`ALTER TABLE` defining a `PRIMARY KEY`/`UNIQUE ... WITHOUT OVERLAPS` with a single column.

## How to fix

Add at least one scalar key column before the `WITHOUT OVERLAPS` range column, for example `PRIMARY KEY (id, valid_at WITHOUT OVERLAPS)`.

## Example

*Illustrative* — a single-column WITHOUT OVERLAPS constraint.

```sql
ALTER TABLE t ADD PRIMARY KEY (valid_at WITHOUT OVERLAPS);
-- ERROR:  constraint using WITHOUT OVERLAPS needs at least two columns
```

## Related

- [column in WITHOUT OVERLAPS is not a range or multirange type](./column-in-without-overlaps-is-not-a-range-or-multirange-type.md)
- [constraint on partitioned table must include all partitioning columns](./constraint-on-partitioned-table-must-include-all-partitioning-columns.md)
