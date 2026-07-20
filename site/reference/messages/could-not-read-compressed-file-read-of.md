---
message: "could not read compressed file \"%s\": read %d of %zu"
slug: could-not-read-compressed-file-read-of
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:352"
reproduced: false
---

# `could not read compressed file "%s": read %d of %zu`

## What it means

`pg_receivewal` read from a compressed WAL file but received fewer bytes than expected. The values give the bytes read against the amount requested. A short read means the compressed segment is truncated or damaged.

## When it happens

It happens during a WAL receive when reading a compressed segment returns too few bytes — usually a partially written or corrupted compressed file, often left by an interrupted run.

## How to fix

Remove the truncated compressed segment from the destination so it can be re-fetched, and check the destination storage health, then rerun `pg_receivewal`. A short read indicates the file was not written completely.

## Example

*Illustrative* — a short read from a compressed segment.

```text
pg_receivewal: fatal: could not read compressed file "000000010000000000000005.gz": read 512 of 4096
```

## Related

- [could not read compressed file](./could-not-read-compressed-file.md)
- [could not open compressed file](./could-not-open-compressed-file.md)
