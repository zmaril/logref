---
message: "\"%s\" is not an index for table \"%s\""
slug: is-not-an-index-for-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/repack.c:783"
  - "postgres/src/backend/commands/tablecmds.c:19234"
reproduced: true
---

# `"%s" is not an index for table "%s"`

## What it means

A command paired a table with an index that is not one of that table's indexes. The placeholders are the index and the table. The relationship the command needs does not hold.

## When it happens

It arises in operations that name both a table and one of its indexes — `CLUSTER table USING index`, `ALTER TABLE ... CLUSTER ON index`, or `REPLICA IDENTITY USING INDEX` — when the index belongs to a different table.

## How to fix

Name an index that belongs to the target table. List a table's indexes with `\d tablename`, and pass one of those. Check for a mixed-up index name from another table.

## Example

*Reproduced* — captured from `reproducers/scenarios/53_vacuum_cluster_concurrency_ddl.sql`.

```sql
CLUSTER repro.churn USING child_amount_idx;
```

Produces:

```text
ERROR:  "child_amount_idx" is not an index for table "churn"
```

## Related

- [index does not belong to table](./index-does-not-belong-to-table.md)
- [is a table](./is-a-table.md)
