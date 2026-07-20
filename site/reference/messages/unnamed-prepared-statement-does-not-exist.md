---
message: "unnamed prepared statement does not exist"
slug: unnamed-prepared-statement-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_PSTATEMENT
    code: "26000"
call_sites:
  - "postgres/src/backend/tcop/postgres.c:1716"
  - "postgres/src/backend/tcop/postgres.c:2762"
reproduced: false
---

# `unnamed prepared statement does not exist`

## What it means

A client on the extended query protocol referred to the unnamed prepared statement, but no unnamed statement is currently prepared on the connection.

## When it happens

It arises when a driver issues a Bind or Describe for the unnamed statement without a preceding Parse, or after the unnamed statement was replaced or discarded — a protocol-sequencing bug in the client.

## How to fix

This is almost always a driver issue rather than something to fix in SQL. Update or configure the client library so it prepares the unnamed statement before binding it; if you maintain the client, ensure Parse precedes Bind/Describe.

## Example

*Illustrative* — binding an unprepared statement.

```text
ERROR:  unnamed prepared statement does not exist
```

## Related

- [unexpected result after CommandComplete: %s](./unexpected-result-after-commandcomplete.md)
- [unexpected message type 0x%02X during COPY from stdin](./unexpected-message-type-0x-during-copy-from-stdin.md)
