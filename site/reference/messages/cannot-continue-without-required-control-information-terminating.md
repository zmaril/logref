---
message: "Cannot continue without required control information, terminating"
slug: cannot-continue-without-required-control-information-terminating
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/controldata.c:605"
reproduced: false
---

# `Cannot continue without required control information, terminating`

## What it means

`pg_upgrade` stopped because it could not read control information it needs from one of the clusters — the data it collects from `pg_controldata`. Without those values it cannot safely proceed with the upgrade.

## When it happens

It occurs during `pg_upgrade` when the old or new cluster's control data cannot be read or is missing expected fields, often due to a wrong data directory or a version mismatch in the tools.

## How to fix

Verify that the `--old-datadir` and `--new-datadir` paths point at valid clusters and that the matching-version `pg_controldata`/`pg_upgrade` binaries are used. Correct the paths or tool versions and rerun.

## Example

*Illustrative* — missing control information.

```text
Cannot continue without required control information, terminating
```

## Related

- [cannot be run as root (pg_upgrade)](./cannot-be-run-as-root-f92c1b.md)
- [cannot dump statistics for relation kind](./cannot-dump-statistics-for-relation-kind.md)
