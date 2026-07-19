---
message: "database cluster is not compatible"
slug: database-cluster-is-not-compatible
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_checksums/pg_checksums.c:573"
reproduced: false
---

# `database cluster is not compatible`

## What it means

`pg_checksums` found that the data directory was created by a different Postgres major version than the tool itself. The on-disk layout the tool understands does not match the cluster's.

## When it happens

It happens when you run `pg_checksums` from one major version against a data directory initialized by another, since the tool must match the cluster's catalog version.

## How to fix

Run the `pg_checksums` that matches the cluster's major version. Use the binary from the same server release that created the data directory. Check the version with `pg_controldata` if you are unsure which one to use.

## Example

*Illustrative* — a version mismatch.

```text
pg_checksums: error: database cluster is not compatible
```

## Related

- [database cluster state problem](./database-cluster-state-problem.md)
- [data type checks failed](./data-type-checks-failed.md)
