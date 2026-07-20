---
message: "invalid reference to FROM-clause entry for table \"%s\""
slug: invalid-reference-to-from-clause-entry-for-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
  - symbol: ERRCODE_UNDEFINED_TABLE
    code: "42P01"
call_sites:
  - "postgres/src/backend/parser/parse_relation.c:496"
  - "postgres/src/backend/parser/parse_relation.c:3855"
  - "postgres/src/backend/parser/parse_relation.c:3864"
reproduced: false
---

# `invalid reference to FROM-clause entry for table "%s"`

## What it means

A column reference named a table that is present in the query but not reachable from the clause where it appears. The table exists in a different part of the query's scope, so the reference cannot bind to it here even though the name is spelled correctly.

## When it happens

Referring in a join's `ON` clause or a subquery to a table that belongs to a scope the reference cannot see — for example naming an outer table from inside a join that does not include it, or crossing a lateral boundary the query does not establish. A frequent cause is joining tables in an order that puts the referenced table outside the current `ON` clause's reach.

## How to fix

Restructure so the referenced table is in scope where you use it. Reorder the joins, move the condition to a `WHERE` clause where both tables are visible, or add `LATERAL` if a subquery genuinely needs to see an earlier `FROM` item. The hint that Postgres emits usually names the table you meant and where it is visible.

## Example

*Illustrative* — referencing a table not visible in this join.

```sql
SELECT * FROM a JOIN b ON a.id = c.id;  -- c is not part of this FROM clause
```

## Related

- [missing from-clause entry for table](./missing-from-clause-entry-for-table.md)
- [table has columns available but columns specified](./table-has-columns-available-but-columns-specified.md)
