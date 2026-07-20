---
message: "data checksums are already disabled in cluster"
slug: data-checksums-are-already-disabled-in-cluster
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_checksums/pg_checksums.c:594"
reproduced: false
---

# `data checksums are already disabled in cluster`

## What it means

`pg_checksums` was told to disable data checksums, but the cluster already has them disabled. There is nothing to change.

## When it happens

It happens when you run `pg_checksums --disable` against a data directory whose checksums are not enabled.

## How to fix

No action is needed — checksums are already off. If you meant to enable them, use `--enable` instead. You can check the current state with `pg_checksums --check` or by reading the control file.

## Example

*Illustrative* — disabling already-disabled checksums.

```text
pg_checksums: error: data checksums are already disabled in cluster
```

## Related

- [data checksums are already enabled in cluster](./data-checksums-are-already-enabled-in-cluster.md)
- [data checksums are not enabled in cluster](./data-checksums-are-not-enabled-in-cluster.md)
