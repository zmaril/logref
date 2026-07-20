---
message: "CUBE is limited to 12 elements"
slug: cube-is-limited-to-12-elements
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TOO_MANY_COLUMNS
    code: "54011"
call_sites:
  - "postgres/src/backend/parser/parse_clause.c:2732"
reproduced: false
---

# `CUBE is limited to 12 elements`

## What it means

A `CUBE` grouping clause listed more than twelve elements. `GROUP BY CUBE (...)` generates every combination of its elements, and the number of groups grows so fast that Postgres caps the element count at twelve.

## When it happens

It happens when you write `GROUP BY CUBE (...)` with more than twelve grouping elements in the parentheses.

## How to fix

Reduce the number of elements in the `CUBE`, since twelve elements already yield thousands of grouping sets. Split the analysis into smaller cubes, or use an explicit `GROUPING SETS` list that names only the combinations you actually need.

## Example

*Illustrative* — a CUBE with too many elements.

```sql
SELECT count(*) FROM t GROUP BY CUBE (a,b,c,d,e,f,g,h,i,j,k,l,m);
-- ERROR:  CUBE is limited to 12 elements
```

## Related

- [cube dimension is too large](./cube-dimension-is-too-large.md)
- [cycle column specified more than once](./cycle-column-specified-more-than-once.md)
