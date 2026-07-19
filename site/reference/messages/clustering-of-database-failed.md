---
message: "clustering of database \"%s\" failed: %s"
slug: clustering-of-database-failed
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/scripts/clusterdb.c:216"
reproduced: false
---

# `clustering of database "%s" failed: %s`

## What it means

The `clusterdb` client tool reported that clustering a whole database did not complete. The appended detail carries the server-side error that stopped the operation.

## When it happens

It occurs during `clusterdb` (often `clusterdb --all` or a per-database run) when the underlying `CLUSTER` command fails on that database.

## How to fix

Read the appended server error to find the cause, such as a lock conflict, a missing clustered index, or insufficient space. Resolve that condition and rerun `clusterdb`.

## Example

*Illustrative* — a database-level cluster failure.

```text
clusterdb: error: clustering of database "app" failed: ERROR:  could not obtain lock
```

## Related

- [clustering of table in database failed](./clustering-of-table-in-database-failed.md)
- [cluster does not support lossy index conditions](./cluster-does-not-support-lossy-index-conditions.md)
