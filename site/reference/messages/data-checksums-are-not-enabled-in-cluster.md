---
message: "data checksums are not enabled in cluster"
slug: data-checksums-are-not-enabled-in-cluster
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_checksums/pg_checksums.c:590"
reproduced: false
---

# `data checksums are not enabled in cluster`

## What it means

`pg_checksums` was asked to verify or operate on checksums, but the cluster does not have data checksums enabled. Without checksums there is nothing to check.

## When it happens

It happens when you run `pg_checksums` in check mode (or another mode that requires them) against a data directory whose checksums are off.

## How to fix

Enable checksums first with `pg_checksums --enable` while the server is shut down, or initialize the cluster with checksums. Once enabled, verification with `--check` has something to validate.

## Example

*Illustrative* — checking a cluster without checksums.

```text
pg_checksums: error: data checksums are not enabled in cluster
```

## Related

- [data checksums are already enabled in cluster](./data-checksums-are-already-enabled-in-cluster.md)
- [data checksums failed to get enabled in all databases, aborting](./data-checksums-failed-to-get-enabled-in-all-databases-aborting.md)
