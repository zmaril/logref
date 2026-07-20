---
message: "invalid string in message"
slug: invalid-string-in-message
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/pqformat.c:592"
  - "postgres/src/backend/libpq/pqformat.c:621"
reproduced: false
---

# `invalid string in message`

## What it means

A protocol message that should contain a null-terminated string did not have a proper terminator within the message bounds. The message is malformed, so the server rejects it.

## When it happens

It arises when a client library encodes a string field incorrectly (missing the trailing null byte or overrunning the message), a proxy corrupts the stream, or the connection has desynchronized.

## How to fix

If a custom client encodes protocol messages, make sure string fields are null-terminated and within the declared message length. For standard clients, suspect a proxy or an unstable network path corrupting the stream. Persistent errors from one source point at that client.

## Example

*Illustrative* — a string field without a terminator.

```text
ERROR:  invalid string in message
```

## Related

- [invalid message length](./invalid-message-length.md)
- [invalid frontend message type](./invalid-frontend-message-type.md)
