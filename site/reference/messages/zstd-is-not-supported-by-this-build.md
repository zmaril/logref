---
message: "zstd is not supported by this build"
slug: zstd-is-not-supported-by-this-build
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/xloginsert.c:821"
  - "postgres/src/backend/access/transam/xloginsert.c:1072"
reproduced: false
---

# `zstd is not supported by this build`

## What it means

A feature requested zstd compression, but this PostgreSQL build was compiled without zstd support.

## When it happens

It arises when zstd is selected for WAL/base-backup/`pg_dump` compression, a zstd-compressed toast method, or a zstd manifest checksum on a server or tool built without the zstd library.

## How to fix

Use a compression method the build supports (such as `pglz`, `lz4` where present, or `gzip` for tools), or install a PostgreSQL build compiled with `--with-zstd`. Check `pg_config` and the tool's build options.

## Example

*Illustrative* — requesting zstd on a build without it.

```text
ERROR:  zstd is not supported by this build
```

## Related

- [unrecognized checksum algorithm: "%s"](./unrecognized-checksum-algorithm.md)
- [could not create SSL context: %s](./could-not-create-ssl-context.md)
