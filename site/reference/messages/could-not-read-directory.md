---
message: "could not read directory \"%s\": %m"
slug: could-not-read-directory
passthrough: false
api: [ereport, pg_fatal, pg_log_error, pg_log_warning]
level: [ERROR, FATAL, WARNING]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/storage/file/fd.c:2991"
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:471"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:997"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:1038"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:1076"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:1113"
  - "postgres/src/bin/pg_rewind/file_ops.c:485"
  - "postgres/src/bin/pg_upgrade/relfilenumber.c:388"
  - "postgres/src/bin/pg_upgrade/relfilenumber.c:426"
  - "postgres/src/common/file_utils.c:174"
  - "postgres/src/common/file_utils.c:338"
  - "postgres/src/common/pgfnames.c:68"
  - "postgres/src/common/rmtree.c:106"
reproduced: false
---

# `could not read directory "%s": %m`

## What it means

Reading directory entries (`readdir()`) failed partway through a scan. The path is the first placeholder and `%m` the OS error. Postgres lists directories to enumerate WAL, relation files, and tablespaces.

## When it happens

Scanning `pg_wal`, a tablespace, or the data directory, and in client tools reading a source directory. Common `%m`: `Input/output error` (failing storage) or `Stale file handle` on network filesystems; permission problems usually surface at open, not read.

## How to fix

Read `%m`. `Input/output error` points at failing storage — check kernel logs and disk health, especially for WAL/data directories. On NFS or similar, transient errors may resolve on retry but indicate an unstable mount. Fix the underlying filesystem condition.

## Example

*Illustrative* — a directory scan hitting an I/O error.

```text
ERROR:  could not read directory "pg_wal": Input/output error
```

## Related

- [could not open directory](./could-not-open-directory.md)
- [could not remove directory](./could-not-remove-directory-d7a17a.md)
