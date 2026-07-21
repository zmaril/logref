---
message: "LZ4 is not supported by this build"
slug: lz4-is-not-supported-by-this-build
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/xloginsert.c:813"
  - "postgres/src/backend/access/transam/xloginsert.c:1061"
reproduced: false
---

# `LZ4 is not supported by this build`

## What it means

An operation requested LZ4 compression, but this Postgres build was compiled without LZ4 support. The feature is unavailable in this binary.

## When it happens

It arises when setting LZ4 as a column compression method, a WAL/TOAST compression option, or a tool's compression choice on a server built without `--with-lz4`.

## How to fix

Use a compression method the build supports (for example `pglz`), or install/switch to a Postgres build compiled with LZ4 support. Check availability by attempting to set the option, or inspect the build's configuration.

## Example

*Illustrative* — requesting LZ4 on a build without it.

```sql
ALTER TABLE t ALTER COLUMN c SET COMPRESSION lz4;  -- not supported by this build
```

## Related

- [invalid compression method](./invalid-compression-method-b1b2db.md)
- [libnuma initialization failed or NUMA is not supported on this platform](./libnuma-initialization-failed-or-numa-is-not-supported-on-this-platform.md)
