---
message: "unrecognized compression algorithm: \"%s\""
slug: unrecognized-compression-algorithm
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/backup/basebackup.c:905"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2643"
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:802"
  - "postgres/src/bin/pg_dump/pg_dump.c:931"
reproduced: true
---

# `unrecognized compression algorithm: "%s"`

## What it means

A compression algorithm name given to a command or tool is not one this build knows. The placeholder is the name. Compression is accepted only for the algorithms Postgres was compiled with — typically `gzip`, `lz4`, and `zstd`, plus `none` — and an unknown or unbuilt name is rejected.

## When it happens

Passing an unsupported algorithm to base backup (`--compress`), `pg_dump`/`pg_restore` compression, WAL compression settings, or a per-column/TOAST compression option — or naming one (like `lz4`/`zstd`) that this particular build was not compiled to support.

## How to fix

Use an algorithm this build supports. Check the spelling and that the server/tool was compiled with the codec: `zstd` and `lz4` require build-time support, whereas `gzip` is generally available. For column compression, valid values are `pglz` and `lz4` (when built with LZ4). Substitute a supported codec or a build that includes the one you need.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__67_backup`); see the reproducer for the triggering workload. It emits:

```text
FATAL:  unrecognized compression algorithm: "%s"
```

## Related

- [could not initialize compression library](./could-not-initialize-compression-library-144690.md)
- [unrecognized option](./unrecognized-option-973965.md)
