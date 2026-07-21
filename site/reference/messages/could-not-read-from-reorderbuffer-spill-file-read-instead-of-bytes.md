---
message: "could not read from reorderbuffer spill file: read %d instead of %u bytes"
slug: could-not-read-from-reorderbuffer-spill-file-read-instead-of-bytes
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/reorderbuffer.c:4630"
  - "postgres/src/backend/replication/logical/reorderbuffer.c:4655"
reproduced: false
---

# `could not read from reorderbuffer spill file: read %d instead of %u bytes`

## What it means

A read from a logical-decoding spill file returned the wrong number of bytes. The counts are what was read versus expected. A short read means the spill file is truncated or damaged.

## When it happens

The spill file was truncated, an out-of-space condition cut an earlier write short, or storage corruption shortened it. It fires while decoding replays a spilled transaction.

## How to fix

Check the spill area for earlier out-of-space or I/O errors — those usually explain the short file. Ensure adequate space under the data directory and healthy storage, then restart the decoding consumer.

## Example

*Illustrative* — a truncated spill file.

```text
ERROR:  could not read from reorderbuffer spill file: read 120 instead of 512 bytes
```

## Related

- [could not read from reorderbuffer spill file](./could-not-read-from-reorderbuffer-spill-file.md)
- [could not write bytes to log file](./could-not-write-bytes-to-log-file.md)
