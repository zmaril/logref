---
message: "cannot check file \"%s\": compression with %s not supported by this build"
slug: cannot-check-file-compression-with-not-supported-by-this-build
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:453"
reproduced: false
---

# `cannot check file "%s": compression with %s not supported by this build`

## What it means

A tool tried to inspect a file's compression, but the compression method it uses was not compiled into this Postgres build. The build lacks support for that algorithm, so it cannot read the file. The placeholders are the file name and the compression method.

## When it happens

It occurs in tools such as `pg_verifybackup` or `pg_waldump` when a backup or file was compressed with a method — for example LZ4 or Zstandard — that the current binaries were not built with.

## How to fix

Use a Postgres build compiled with the required compression support, or recompress the file with a method this build understands. Check `pg_config` for the compression libraries the binaries were built against.

## Example

*Illustrative* — an unsupported compression method.

```text
error: cannot check file "base.tar.zst": compression with zstd not supported by this build
```

## Related

- [cannot check relation](./cannot-check-relation.md)
- [cannot check index](./cannot-check-index.md)
