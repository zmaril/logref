---
message: "data checksums are already enabled in cluster"
slug: data-checksums-are-already-enabled-in-cluster
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_checksums/pg_checksums.c:598"
reproduced: false
---

# `data checksums are already enabled in cluster`

## What it means

`pg_checksums` was told to enable data checksums, but the cluster already has them enabled. There is nothing to change.

## When it happens

It happens when you run `pg_checksums --enable` against a data directory that already has checksums turned on.

## How to fix

No action is needed — checksums are already on. If you meant to verify them, use `--check`; if you meant to turn them off, use `--disable`. Confirm the current state with `pg_checksums --check`.

## Example

*Illustrative* — enabling already-enabled checksums.

```text
pg_checksums: error: data checksums are already enabled in cluster
```

## Related

- [data checksums are already disabled in cluster](./data-checksums-are-already-disabled-in-cluster.md)
- [data checksums are not enabled in cluster](./data-checksums-are-not-enabled-in-cluster.md)
