---
message: "cannot use multiple jobs to reindex system catalogs"
slug: cannot-use-multiple-jobs-to-reindex-system-catalogs
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/scripts/reindexdb.c:217"
reproduced: false
---

# `cannot use multiple jobs to reindex system catalogs`

## What it means

`reindexdb` was asked to reindex system catalogs with more than one concurrent job. Reindexing catalogs must be serialized, so parallel jobs cannot be used for that part of the work.

## When it happens

It occurs with `reindexdb --jobs N` (N greater than one) together with `--system`, or a run that includes system catalogs.

## How to fix

Drop `--jobs` when reindexing system catalogs, or reindex user tables in parallel and reindex the catalogs in a separate single-job run.

## Example

*Illustrative* — parallel reindex of catalogs.

```text
reindexdb: error: cannot use multiple jobs to reindex system catalogs
```

## Related

- [cannot specify both --single-transaction and multiple jobs](./cannot-specify-both-single-transaction-and-multiple-jobs.md)
- [cannot upgrade to/from the same system catalog version when using tablespaces](./cannot-upgrade-to-from-the-same-system-catalog-version-when-using-tablespaces.md)
