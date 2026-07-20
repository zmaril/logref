---
message: "unexpected EOF on client connection with an open transaction"
slug: unexpected-eof-on-client-connection-with-an-open-transaction
passthrough: false
api: [ereport]
level: [COMMERROR, ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/src/backend/commands/copyfromparse.c:282"
  - "postgres/src/backend/commands/copyfromparse.c:307"
  - "postgres/src/backend/replication/walsender.c:785"
  - "postgres/src/backend/replication/walsender.c:811"
  - "postgres/src/backend/tcop/postgres.c:381"
reproduced: false
---

# `unexpected EOF on client connection with an open transaction`

## What it means

The client's connection closed unexpectedly while a transaction was still open. The server had an in-progress transaction for that session and the socket reached end-of-file without a proper close. The open transaction is rolled back.

## When it happens

A client process crashed, was killed, or lost its network connection mid-transaction; a connection pooler dropped the backend; or the client exited without committing/closing cleanly. At `COMMERROR` it is logged server-side; the transaction is aborted.

## How to fix

The transaction rolled back safely, so no data is left half-applied. Investigate why the client vanished: application crashes, aggressive network/idle timeouts, pooler behavior, or a client killed while working. Ensure clients commit or roll back and close connections cleanly, and review timeout settings if it happens often.

## Example

*Illustrative* — a client lost mid-transaction.

```text
LOG:  unexpected EOF on client connection with an open transaction
```

## Related

- [could not receive data from WAL stream](./could-not-receive-data-from-wal-stream.md)
- [could not establish connection](./could-not-establish-connection.md)
