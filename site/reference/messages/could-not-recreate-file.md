---
message: "could not recreate file \"%s\": %m"
slug: could-not-recreate-file
passthrough: false
api: [ereport]
level: [ERROR, LOG]
call_sites:
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:2629"
  - "postgres/src/backend/access/transam/twophase.c:1764"
reproduced: false
---

# `could not recreate file "%s": %m`

## What it means

A file could not be re-created during a save or rewrite. The `%s` is the path and the `%m` is the operating-system error. It fires when `pg_stat_statements` rewrites its query-text file or two-phase state is rewritten.

## When it happens

The target directory was not writable, the disk was full, or an I/O or permissions error occurred while replacing the file. It is a housekeeping write, not a query fault.

## How to fix

Read the trailing error. Ensure the relevant directory (the data directory or `pg_stat_tmp`) is writable and has space. Fix permissions or free space and let the operation retry.

## Example

*Illustrative* — the query-text file could not be rewritten.

```text
LOG:  could not recreate file "pg_stat_tmp/pgss_query_texts.stat": No space left on device
```

## Related

- [could not write to file](./could-not-write-to-file-ecc639.md)
- [could not set permissions on file](./could-not-set-permissions-on-file.md)
