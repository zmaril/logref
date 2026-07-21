---
message: "could not write %d bytes to WAL file \"%s\": %s"
slug: could-not-write-bytes-to-wal-file
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/receivelog.c:1142"
reproduced: false
---

# `could not write %d bytes to WAL file "%s": %s`

## What it means

`pg_receivewal` could not write a chunk of streamed write-ahead log to a segment file. The placeholders are the byte count and the file, and the trailing text is the underlying error.

## When it happens

It fires while `pg_receivewal` streams WAL from the server and writes it to the target directory, when a write fails — most often a full disk or an I/O error on the destination.

## How to fix

Read the error. `No space left on device` means the target filesystem is full; free space so streaming can continue. An I/O error points at failing storage. Confirm the target directory is writable and has room, then restart `pg_receivewal`.

## Example

*Illustrative* — a WAL write ran out of space.

```text
pg_receivewal: error: could not write 8192 bytes to WAL file "000000010000000000000009.partial": No space left on device
```

## Related

- [could not write timeline history file](./could-not-write-timeline-history-file.md)
- [could not write to WAL segment at offset, length](./could-not-write-to-wal-segment-at-offset-length.md)
