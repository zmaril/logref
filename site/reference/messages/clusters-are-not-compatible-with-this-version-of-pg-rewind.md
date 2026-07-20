---
message: "clusters are not compatible with this version of pg_rewind"
slug: clusters-are-not-compatible-with-this-version-of-pg-rewind
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/pg_rewind.c:760"
reproduced: false
---

# `clusters are not compatible with this version of pg_rewind`

## What it means

`pg_rewind` was run against clusters whose on-disk version does not match the tool's version. The control-file layout differs, so this build of `pg_rewind` cannot safely operate on them.

## When it happens

It occurs when `pg_rewind` from one major version is pointed at data directories initialized by a different major version.

## How to fix

Use the `pg_rewind` binary that matches the clusters' major version. Run the tool from the same release as the servers that own the data directories.

## Example

*Illustrative* — a version mismatch.

```text
pg_rewind: fatal: clusters are not compatible with this version of pg_rewind
```

## Related

- [cluster is not compatible with this version of pg_checksums](./cluster-is-not-compatible-with-this-version-of-pg-checksums.md)
- [cluster must be shut down](./cluster-must-be-shut-down.md)
