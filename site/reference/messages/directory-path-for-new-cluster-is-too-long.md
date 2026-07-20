---
message: "directory path for new cluster is too long"
slug: directory-path-for-new-cluster-is-too-long
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/pg_upgrade.c:291"
  - "postgres/src/bin/pg_upgrade/pg_upgrade.c:304"
  - "postgres/src/bin/pg_upgrade/pg_upgrade.c:311"
  - "postgres/src/bin/pg_upgrade/pg_upgrade.c:318"
  - "postgres/src/bin/pg_upgrade/pg_upgrade.c:336"
  - "postgres/src/bin/pg_upgrade/pg_upgrade.c:347"
reproduced: false
---

# `directory path for new cluster is too long`

## What it means

During `pg_upgrade`, the path to the new cluster's data directory is too long to fit within the fixed-size buffers Postgres uses for socket and internal paths. Unix socket paths in particular have a tight length limit, and a deep data-directory path can push generated paths past it.

## When it happens

Running `pg_upgrade` with a `--new-datadir` whose absolute path is very long, especially when combined with the Unix-socket directory it derives. Deeply nested or verbose directory names are the cause.

## How to fix

Use a shorter path for the new data directory — move it closer to the filesystem root or shorten intermediate directory names. `pg_upgrade` also lets you set a shorter socket directory (`--socketdir`) to keep the Unix-socket path within limits. Reduce the path length and retry.

## Example

*Illustrative* — an over-long new-cluster path.

```sh
pg_upgrade -d old -D /very/deeply/nested/long/path/to/new/cluster/data ...
```

Produces:

```text
FATAL:  directory path for new cluster is too long
```

## Related

- [directory exists but is not empty](./directory-exists-but-is-not-empty.md)
- [database files are incompatible with server](./database-files-are-incompatible-with-server.md)
