---
message: "this build does not support compression with %s"
slug: this-build-does-not-support-compression-with
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_gzip.c:453"
  - "postgres/src/bin/pg_dump/compress_gzip.c:460"
  - "postgres/src/bin/pg_dump/compress_lz4.c:795"
  - "postgres/src/bin/pg_dump/compress_lz4.c:802"
  - "postgres/src/bin/pg_dump/compress_zstd.c:26"
  - "postgres/src/bin/pg_dump/compress_zstd.c:32"
  - "postgres/src/fe_utils/astreamer_gzip.c:140"
  - "postgres/src/fe_utils/astreamer_gzip.c:275"
  - "postgres/src/fe_utils/astreamer_lz4.c:102"
  - "postgres/src/fe_utils/astreamer_lz4.c:302"
  - "postgres/src/fe_utils/astreamer_zstd.c:130"
  - "postgres/src/fe_utils/astreamer_zstd.c:285"
reproduced: false
---

# `this build does not support compression with %s`

## What it means

A compression method was requested but this Postgres build was compiled without support for it. The placeholder names the method (for example `gzip`, `lz4`, or `zstd`). The feature is optional at build time, and the binary you are running lacks the required library.

## When it happens

Requesting `--compress=lz4`/`zstd` in `pg_basebackup`, a compressed WAL/backup option, or a compressed `COPY`/dump against a server or client built without that library. Common on minimal or distribution packages that omit `--with-lz4`/`--with-zstd`.

## How to fix

Use a compression method the build supports, or install/use a build compiled with the needed library (`--with-lz4`, `--with-zstd`, `--with-zlib`). For client-side compression the client binary must support it; for server-side, the server must. Check `pg_config` or the package's build options to see what is enabled.

## Example

*Illustrative* — requesting an uncompiled compression method.

```sh
pg_basebackup -D out --compress=zstd
```

Produces:

```text
pg_basebackup: error: this build does not support compression with zstd
```

## Related

- [could not compress data](./could-not-compress-data.md)
- [could not initialize compression library](./could-not-initialize-compression-library-d6693c.md)
