---
message: "cannot lock rows in foreign table \"%s\""
slug: cannot-lock-rows-in-foreign-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/executor/execMain.c:1269"
  - "postgres/src/backend/executor/execMain.c:2928"
  - "postgres/src/backend/executor/nodeLockRows.c:133"
reproduced: false
---

# `cannot lock rows in foreign table "%s"`

## What it means

A query used explicit row locking (`SELECT ... FOR UPDATE`/`FOR SHARE`) on a foreign table. The placeholder names the table. Foreign tables live in another system, and Postgres cannot take and hold local row locks on rows that it does not store, so row-level locking against them is not supported.

## When it happens

Adding `FOR UPDATE`/`FOR SHARE`/`FOR NO KEY UPDATE`/`FOR KEY SHARE` to a query that includes a foreign table, directly or via a join whose locking clause reaches the foreign table.

## How to fix

Remove the row-locking clause where it applies to the foreign table, or restrict `FOR UPDATE` to the local tables (`FOR UPDATE OF local_alias`). If you need concurrency control on the remote data, handle it on the remote server or through the foreign data wrapper's own mechanisms.

## Example

*Illustrative* — FOR UPDATE on a foreign table.

```sql
SELECT * FROM my_foreign_tbl FOR UPDATE;  -- cannot lock rows in foreign table
```

## Related

- [access to non-system foreign table is restricted](./access-to-non-system-foreign-table-is-restricted.md)
- [cannot collect transition tuples from child foreign tables](./cannot-collect-transition-tuples-from-child-foreign-tables.md)
