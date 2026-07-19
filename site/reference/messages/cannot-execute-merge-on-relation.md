---
message: "cannot execute MERGE on relation \"%s\""
slug: cannot-execute-merge-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/optimizer/plan/createplan.c:7191"
  - "postgres/src/backend/parser/parse_merge.c:201"
  - "postgres/src/backend/rewrite/rewriteHandler.c:1739"
reproduced: false
---

# `cannot execute MERGE on relation "%s"`

## What it means

A `MERGE` statement targeted a relation kind that `MERGE` does not support. The placeholder names the relation. `MERGE` requires an ordinary, directly-modifiable target table; views, foreign tables, and certain other relation kinds cannot be its target.

## When it happens

Running `MERGE INTO` against a view, a foreign table, a partitioned setup or relation kind not supported as a `MERGE` target, or another object that is not a plain modifiable table.

## How to fix

Target a base table that `MERGE` supports. For a view, either merge into the underlying table or use an `INSTEAD OF` trigger with separate statements. For foreign tables and other unsupported kinds, use the operations those objects do support (`INSERT`/`UPDATE`/`DELETE`) instead of `MERGE`.

## Example

*Illustrative* — MERGE into an unsupported relation.

```sql
MERGE INTO my_view v USING src s ON ... ;  -- cannot execute MERGE on relation "my_view"
```

## Related

- [command cannot affect row a second time](./command-cannot-affect-row-a-second-time.md)
- [cannot update table](./cannot-update-table.md)
