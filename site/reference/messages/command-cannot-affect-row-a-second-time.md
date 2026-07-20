---
message: "%s command cannot affect row a second time"
slug: command-cannot-affect-row-a-second-time
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CARDINALITY_VIOLATION
    code: "21000"
call_sites:
  - "postgres/src/backend/executor/nodeModifyTable.c:3073"
  - "postgres/src/backend/executor/nodeModifyTable.c:3794"
  - "postgres/src/backend/executor/nodeModifyTable.c:3991"
reproduced: false
---

# `%s command cannot affect row a second time`

## What it means

A data-modifying statement tried to change the same row twice in one execution, which SQL forbids because the outcome would be order-dependent and ambiguous. The placeholder names the command. `MERGE` and `INSERT ... ON CONFLICT` most often hit this when their source matches one target row more than once.

## When it happens

A `MERGE` whose join matches a target row from multiple source rows, or `INSERT ... ON CONFLICT DO UPDATE` where the inserted set contains duplicate conflict keys, so one target row would be updated twice.

## How to fix

Deduplicate the source so each target row is affected at most once: aggregate or `DISTINCT ON` the source before the `MERGE`/upsert, or tighten the `ON`/conflict condition. For `ON CONFLICT`, ensure the incoming rows do not contain two rows with the same conflict key.

## Example

*Illustrative* — a source matching one target row twice.

```sql
MERGE INTO t USING (VALUES (1),(1)) s(id) ON t.id=s.id WHEN MATCHED THEN UPDATE SET ...;
```

## Related

- [more than one row returned by a subquery used as an expression](./more-than-one-row-returned-by-a-subquery-used-as-an-expression.md)
- [cannot execute MERGE on relation](./cannot-execute-merge-on-relation.md)
