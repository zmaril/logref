---
message: "COPY from stdin failed: %s"
slug: copy-from-stdin-failed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_QUERY_CANCELED
    code: "57014"
call_sites:
  - "postgres/src/backend/commands/copyfromparse.c:321"
  - "postgres/src/backend/replication/walsender.c:832"
reproduced: false
---

# `COPY from stdin failed: %s`

## What it means

A `COPY ... FROM STDIN` was interrupted before the data stream completed. The placeholder is the underlying reason. The client stopped sending, cancelled, or disconnected while the server was still reading copy data.

## When it happens

A client cancelling a `COPY FROM STDIN` mid-stream, a dropped connection during bulk load, or an application that stops feeding data before sending the copy terminator.

## How to fix

Ensure the client sends the complete copy stream and its end marker, and does not cancel or disconnect during the load. Check application logs and network stability for the interruption. Re-run the `COPY` once the client feeds data reliably.

## Example

*Illustrative* — a client aborting a COPY FROM STDIN.

```text
ERROR:  COPY from stdin failed: canceled by user
```

## Related

- [cannot COPY to/from client in PL/pgSQL](./cannot-copy-to-from-client-in-pl-pgsql.md)
- [COPY not recognized](./copy-not-recognized.md)
