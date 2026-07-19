---
message: "invalid compression specification: %s"
slug: invalid-compression-specification
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/backup/basebackup.c:974"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2649"
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:809"
  - "postgres/src/bin/pg_dump/pg_dump.c:938"
reproduced: false
---

# `invalid compression specification: %s`

## What it means

A compression option string could not be parsed or requested an unsupported setting. The placeholder is the detail. Compression specs name a method and optional parameters (like `gzip:9` or `zstd:level=3`); a bad method, level, or syntax is rejected.

## When it happens

Passing a malformed or unsupported compression specification to a base backup, `pg_basebackup`, `pg_dump`, or a WAL/`basebackup` option — an unknown method, an out-of-range level, or a method not compiled into the build.

## How to fix

Use a supported method and valid parameters. Check which methods the build includes (`gzip`, `lz4`, `zstd` depending on how Postgres was compiled), keep levels within each method's range, and follow the `method:detail` syntax. Read the detail text for the specific problem.

## Example

*Illustrative* — an unsupported compression method.

```text
ERROR:  invalid compression specification: unrecognized compression method "brotli"
```

## Related

- [compression is not supported by tar archive format](./compression-is-not-supported-by-tar-archive-format.md)
- [could not decompress data](./could-not-decompress-data.md)
