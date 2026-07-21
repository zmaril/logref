---
message: "database files are incompatible with server"
slug: database-files-are-incompatible-with-server
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:4450"
  - "postgres/src/backend/access/transam/xlog.c:4460"
  - "postgres/src/backend/access/transam/xlog.c:4486"
  - "postgres/src/backend/access/transam/xlog.c:4496"
  - "postgres/src/backend/access/transam/xlog.c:4506"
  - "postgres/src/backend/access/transam/xlog.c:4512"
  - "postgres/src/backend/access/transam/xlog.c:4522"
  - "postgres/src/backend/access/transam/xlog.c:4532"
  - "postgres/src/backend/access/transam/xlog.c:4542"
  - "postgres/src/backend/access/transam/xlog.c:4552"
  - "postgres/src/backend/access/transam/xlog.c:4562"
  - "postgres/src/backend/access/transam/xlog.c:4572"
  - "postgres/src/backend/access/transam/xlog.c:4582"
  - "postgres/src/backend/utils/init/miscinit.c:1766"
reproduced: false
---

# `database files are incompatible with server`

## What it means

The server refused to start (or attach to a data directory) because the on-disk files were created by an incompatible build. Postgres checks the catalog version, block size, and other layout parameters recorded in `pg_control` against the running binary; a mismatch is fatal because the binary cannot safely interpret the files.

## When it happens

Pointing a server binary at a data directory initialized by a different major version, a build with a different `--with-blocksize`/`--with-wal-blocksize`, or a different integer/float date-time or checksum setting. It commonly happens after upgrading packages without migrating the data directory, or mixing 32-bit and 64-bit builds.

## How to fix

Use the binary that matches the data directory's version and build options, or migrate the data properly with `pg_upgrade` (or dump/restore) to the new major version. The detail line names which parameter mismatched (catalog version, block size, etc.). Never try to force a mismatched binary onto the directory — it cannot read the files correctly.

## Example

*Illustrative* — a newer server started on an older data directory.

```text
FATAL:  database files are incompatible with server
DETAIL:  The data directory was initialized by PostgreSQL version 15, which is not compatible with this version 17.
```

## Related

- [controldata retrieval problem](./controldata-retrieval-problem.md)
- [could not locate a valid checkpoint record](./could-not-locate-a-valid-checkpoint-record-at.md)
