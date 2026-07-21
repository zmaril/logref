---
message: "could not get data directory using %s: %m"
slug: could-not-get-data-directory-using-2a9020
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/option.c:474"
reproduced: false
---

# `could not get data directory using %s: %m`

## What it means

`pg_upgrade` ran a command against one of the clusters to learn its data directory and the command failed. The `%s` value names what it queried and `%m` gives the reason. It needs each cluster's real data directory to proceed.

## When it happens

It happens at the start of `pg_upgrade` while probing the old or new cluster, when the query for the data directory fails — often a wrong binary path, a cluster that will not start, or a permissions problem.

## How to fix

Confirm the `--old-bindir`/`--new-bindir` and data-directory options point at matching, runnable installations, and that the account running `pg_upgrade` can start each cluster and read its files. Fix the paths or permissions and rerun.

## Example

*Illustrative* — pg_upgrade cannot read a cluster's data directory.

```text
pg_upgrade: fatal: could not get data directory using SHOW data_directory: No such file or directory
```

## Related

- [could not get data directory using](./could-not-get-data-directory-using-34e6aa.md)
- [could not get server version](./could-not-get-server-version.md)
