---
message: "cannot run pg_upgrade from inside the new cluster data directory on Windows"
slug: cannot-run-pg-upgrade-from-inside-the-new-cluster-data-directory-on-windows
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/option.c:297"
reproduced: false
---

# `cannot run pg_upgrade from inside the new cluster data directory on Windows`

## What it means

`pg_upgrade` was started with its working directory inside the new cluster's data directory on Windows. On Windows this holds a lock that would block the upgrade, so the tool refuses to run from there.

## When it happens

It occurs on Windows when the current directory when invoking `pg_upgrade` is somewhere under the new cluster's data directory.

## How to fix

Change to a directory outside both clusters' data directories before running `pg_upgrade`. Run the tool from a neutral working directory such as a scratch folder.

## Example

*Illustrative* — pg_upgrade run from inside the new data dir.

```text
pg_upgrade: error: cannot run pg_upgrade from inside the new cluster data directory on Windows
```

## Related

- [cannot specify a database name with --all](./cannot-specify-a-database-name-with-all.md)
- [cannot reindex all databases and a specific one at the same time](./cannot-reindex-all-databases-and-a-specific-one-at-the-same-time.md)
