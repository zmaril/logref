---
message: "unexpected EOF in COPY data"
slug: unexpected-eof-in-copy-data
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_BAD_COPY_FILE_FORMAT
    code: "22P04"
call_sites:
  - "postgres/src/backend/commands/copyfromparse.c:2286"
  - "postgres/src/backend/commands/copyfromparse.c:2305"
reproduced: false
---

# `unexpected EOF in COPY data`

## What it means

A `COPY` operation reading data in binary format reached the end of its input before the data stream was complete, so the row it was assembling could not be finished.

## When it happens

It arises during `COPY ... FROM` with `FORMAT binary` when the file or client stream is truncated, or when a binary dump is fed to a server that expected more trailing bytes such as the file trailer.

## How to fix

Confirm the input file is complete and was produced in binary format by a compatible server. Re-export the data if the file was cut short, and check for a network interruption when the source is a client stream.

## Example

*Illustrative* — a truncated binary COPY file.

```text
ERROR:  unexpected EOF in COPY data
```

## Related

- [unexpected message type 0x%02X during COPY from stdin](./unexpected-message-type-0x-during-copy-from-stdin.md)
- [unexpected EOF on standby connection](./unexpected-eof-on-standby-connection.md)
