---
message: "unexpected message type 0x%02X during COPY from stdin"
slug: unexpected-message-type-0x-during-copy-from-stdin
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/commands/copyfromparse.c:298"
  - "postgres/src/backend/replication/walsender.c:801"
reproduced: false
---

# `unexpected message type 0x%02X during COPY from stdin`

## What it means

During `COPY ... FROM STDIN` the server received a protocol message whose type byte is not one of those valid in copy-in mode, so it aborted the transfer.

## When it happens

It arises when a client sends the wrong frame while streaming copy data — a driver bug, a desynchronized protocol state, or raw data sent where a `CopyData` message was required.

## How to fix

Use a client library's copy API rather than hand-rolling the protocol. If you maintain the client, ensure only `CopyData`/`CopyDone`/`CopyFail` messages are sent between the copy start and end, and check for a framing bug.

## Example

*Illustrative* — a stray message during copy-in.

```text
ERROR:  unexpected message type 0x50 during COPY from stdin
```

## Related

- [unexpected EOF in COPY data](./unexpected-eof-in-copy-data.md)
- [unexpected result after CommandComplete: %s](./unexpected-result-after-commandcomplete.md)
