---
message: "could not initialize LZ4 compression: %s"
slug: could-not-initialize-lz4-compression
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_lz4.c:313"
reproduced: false
---

# `could not initialize LZ4 compression: %s`

## What it means

`pg_dump` tried to set up LZ4 compression for archive output and the LZ4 library reported an error. The `%s` value gives the library detail. It initializes the compressor before writing compressed data.

## When it happens

It happens during an LZ4-compressed dump, when the LZ4 stream cannot be initialized — usually a problem in the linked LZ4 library or an invalid compression setting.

## How to fix

Confirm the `pg_dump` build has working LZ4 support and the LZ4 library is healthy, and check the compression option you passed. Choosing a different compression method (for example gzip or none) is a workaround if the LZ4 library is the problem.

## Example

*Illustrative* — LZ4 setup failed during a dump.

```text
pg_dump: fatal: could not initialize LZ4 compression: generic error code
```

## Related

- [could not generate temporary file name](./could-not-generate-temporary-file-name.md)
- [could not get server version](./could-not-get-server-version.md)
