---
message: "could not decompress file \"%s\": %s"
slug: could-not-decompress-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:420"
reproduced: false
---

# `could not decompress file "%s": %s`

## What it means

`pg_receivewal` could not decompress a compressed WAL file. The `%s` gives the library's reason. The compressed file could not be expanded.

## When it happens

It happens while `pg_receivewal` reads a previously written compressed segment, when decompression fails — usually a truncated or corrupted file.

## How to fix

Check that the compressed WAL file is complete and undamaged. Remove a truncated file so it can be re-streamed, and confirm the destination storage is healthy.

## Example

*Illustrative* — a compressed WAL file that will not decompress.

```text
pg_receivewal: fatal: could not decompress file "00000001...gz": ...reason...
```

## Related

- [could not decompress](./could-not-decompress.md)
- [could not create compressed file](./could-not-create-compressed-file.md)
