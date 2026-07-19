---
message: "cluster is not compatible with this version of pg_checksums"
slug: cluster-is-not-compatible-with-this-version-of-pg-checksums
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_checksums/pg_checksums.c:569"
reproduced: false
---

# `cluster is not compatible with this version of pg_checksums`

## What it means

`pg_checksums` was run against a data directory whose on-disk version does not match the tool's version. The control-file layout differs, so this build of `pg_checksums` cannot safely operate on the cluster.

## When it happens

It occurs when `pg_checksums` from one major version is pointed at a data directory initialized by a different major version.

## How to fix

Use the `pg_checksums` binary that matches the cluster's major version. Run the tool from the same release as the server that owns the data directory.

## Example

*Illustrative* — a version mismatch.

```text
pg_checksums: fatal: cluster is not compatible with this version of pg_checksums
```

## Related

- [clusters are not compatible with this version of pg_rewind](./clusters-are-not-compatible-with-this-version-of-pg-rewind.md)
- [cluster must be shut down](./cluster-must-be-shut-down.md)
