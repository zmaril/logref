---
message: "compression detail cannot be specified unless compression is enabled"
slug: compression-detail-cannot-be-specified-unless-compression-is-enabled
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/backup/basebackup.c:961"
reproduced: false
---

# `compression detail cannot be specified unless compression is enabled`

## What it means

A base-backup request supplied a compression detail (such as a level) but did not enable a compression method. Detail options only apply once a compression method is selected.

## When it happens

It happens with `pg_basebackup` or the replication `BASE_BACKUP` command when a compression-level or detail option is given while the compression method is `none`.

## How to fix

Enable a compression method (for example `--compress=gzip:9` or `--compress=zstd:level=7`), or drop the detail option if you do not want compression.

## Example

*Illustrative* — a detail without a method.

```text
ERROR:  compression detail cannot be specified unless compression is enabled
```

## Related

- [compression with is not yet supported](./compression-with-is-not-yet-supported.md)
- [compressed array is too big](./compressed-array-is-too-big-recreate-index-using-gist-intbig-ops-opclass-instead.md)
