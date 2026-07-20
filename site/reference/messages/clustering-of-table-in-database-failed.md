---
message: "clustering of table \"%s\" in database \"%s\" failed: %s"
slug: clustering-of-table-in-database-failed
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/scripts/clusterdb.c:213"
reproduced: false
---

# `clustering of table "%s" in database "%s" failed: %s`

## What it means

The `clusterdb` client tool reported that clustering a specific table did not complete. The message names the table and database, and the appended detail carries the server-side error.

## When it happens

It occurs during `clusterdb` when the `CLUSTER` command on the named table fails, for example because the table has no clustered index or a lock could not be acquired.

## How to fix

Read the appended server error and address it: set a clustered index with `ALTER TABLE ... CLUSTER ON index` if none is marked, resolve lock contention, or free disk space, then rerun.

## Example

*Illustrative* — a table-level cluster failure.

```text
clusterdb: error: clustering of table "t" in database "app" failed: ERROR:  there is no previously clustered index for table "t"
```

## Related

- [clustering of database failed](./clustering-of-database-failed.md)
- [cluster does not support lossy index conditions](./cluster-does-not-support-lossy-index-conditions.md)
