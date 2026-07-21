---
message: "unable to initialize LZ4 library: %s"
slug: unable-to-initialize-lz4-library
passthrough: false
api: [pg_fatal, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_lz4.c:418"
  - "postgres/src/bin/pg_dump/compress_lz4.c:519"
reproduced: false
---

# `unable to initialize LZ4 library: %s`

## What it means

Postgres tried to use LZ4 compression and the LZ4 library could not be initialized. The placeholder carries the underlying reason. LZ4-based compression (for TOAST, WAL, or backups) is unavailable when this fails.

## When it happens

It arises when an LZ4 code path runs but the library fails to set up — for example a resource problem, or a build/runtime where LZ4 support is present but the library call fails. On builds without LZ4 support, a different not-compiled-in message appears.

## How to fix

Read the reason in the message. Confirm the LZ4 library is properly installed and loadable, and that the server build includes LZ4 support. If a specific object uses LZ4 compression and the library is unavailable, switch it to a supported method (for example `pglz`).

## Example

*Illustrative* — LZ4 initialization failing.

```text
ERROR:  unable to initialize LZ4 library: version mismatch
```

## Related

- [%s: %s requires %s](./requires.md)
- [server version: %s; %s version: %s](./server-version-version.md)
