---
message: "end_lsn is not set in commit prepared message"
slug: end-lsn-is-not-set-in-commit-prepared-message
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/proto.c:281"
reproduced: false
---

# `end_lsn is not set in commit prepared message`

## What it means

An internal logical-replication protocol guard. A `COMMIT PREPARED` message arrived on the logical stream without its end LSN set, which the protocol requires. This is a "can't happen" consistency check on the stream.

## When it happens

It fires on the subscriber while decoding a `COMMIT PREPARED` logical-replication message that is missing its end LSN, indicating a protocol or version mismatch rather than user SQL.

## How to fix

This is not a user query error. Confirm the publisher and subscriber are compatible versions. If it recurs, capture both servers' logs and versions and report it to the PostgreSQL developers; the stream may be corrupted or mis-versioned.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  end_lsn is not set in commit prepared message
```

## Related

- [end_lsn is not set in message](./end-lsn-is-not-set-in-message.md)
- [end_lsn not set in begin prepare message](./end-lsn-not-set-in-begin-prepare-message.md)
