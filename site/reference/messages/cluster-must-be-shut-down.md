---
message: "cluster must be shut down"
slug: cluster-must-be-shut-down
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_checksums/pg_checksums.c:586"
reproduced: false
---

# `cluster must be shut down`

## What it means

An offline tool was run against a data directory whose server is still running or was not shut down cleanly. The tool needs exclusive, consistent access to the files, so it refuses to proceed while the cluster is active.

## When it happens

It occurs with tools such as `pg_checksums`, `pg_resetwal`, or `pg_rewind` when the target cluster is running or was stopped in an unclean state.

## How to fix

Stop the server cleanly with `pg_ctl stop -m fast` and confirm it is fully shut down, then run the tool. If it crashed, start and cleanly stop it first so the state is consistent.

## Example

*Illustrative* — a running cluster for an offline tool.

```text
pg_checksums: fatal: cluster must be shut down
```

## Related

- [cluster is not compatible with this version of pg_checksums](./cluster-is-not-compatible-with-this-version-of-pg-checksums.md)
- [checksums are being enabled in the old cluster](./checksums-are-being-enabled-in-the-old-cluster.md)
