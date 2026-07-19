---
message: "could not write to compressed file \"%s\": %s"
slug: could-not-write-to-compressed-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/fe_utils/astreamer_gzip.c:167"
reproduced: false
---

# `could not write to compressed file "%s": %s`

## What it means

A front-end tool could not write to a gzip-compressed output file. The placeholder is the file and the trailing text is the compression library's error. This backs compressed output in tools like `pg_receivewal` and `pg_basebackup`.

## When it happens

It fires while a tool writes compressed data and the write fails — a full disk, an I/O error, or a problem inside the compression stream.

## How to fix

Read the error. A disk-full or I/O problem on the output filesystem is the common cause; free space or check the storage. Confirm the output directory is writable and rerun. If the library reports a stream error, ensure the tool and its compression library are a healthy build.

## Example

*Illustrative* — a compressed write failed.

```text
pg_receivewal: error: could not write to compressed file "000000010000000000000009.gz.partial": No space left on device
```

## Related

- [could not seek in compressed file](./could-not-seek-in-compressed-file.md)
- [could not set compression level](./could-not-set-compression-level.md)
