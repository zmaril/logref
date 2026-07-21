---
message: "data directory is of wrong version"
slug: data-directory-is-of-wrong-version
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:474"
  - "postgres/src/bin/pg_checksums/pg_checksums.c:557"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:579"
reproduced: false
---

# `data directory is of wrong version`

## What it means

A tool (here `pg_createsubscriber`) found a data directory whose version does not match what it expects. The version is recorded in the directory's `PG_VERSION` file; a mismatch means the directory belongs to a different major version than the tool/server being used.

## When it happens

Pointing a tool at a data directory created by a different major PostgreSQL version, or mixing binaries and data directories across versions after an upgrade.

## How to fix

Use binaries and tools that match the data directory's major version (`cat PG_VERSION` in the directory to confirm), or upgrade the data directory to the target version with `pg_upgrade` before using the newer tools against it. Do not run version-N tools against a version-M data directory.

## Example

*Illustrative* — a version mismatch on the data directory.

```text
pg_createsubscriber: error: data directory is of wrong version
```

## Related

- [could not stat data directory](./could-not-stat-data-directory.md)
- [file contains which is not compatible with this program's version](./file-contains-which-is-not-compatible-with-this-program-s-version.md)
