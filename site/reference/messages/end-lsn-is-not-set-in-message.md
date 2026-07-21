---
message: "end_lsn is not set in %s message"
slug: end-lsn-is-not-set-in-message
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/proto.c:214"
reproduced: false
---

# `end_lsn is not set in %s message`

## What it means

An internal logical-replication protocol guard. A streamed message arrived without its end LSN set, which the protocol requires. The placeholder names the message type. This is a "can't happen" consistency check.

## When it happens

It fires on the subscriber while decoding a logical-replication message missing its end LSN, indicating a protocol or version mismatch.

## How to fix

This is not a user query error. Confirm publisher and subscriber versions are compatible. If it recurs, capture both servers' logs and versions and report it to the PostgreSQL developers.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  end_lsn is not set in commit message
```

## Related

- [end_lsn is not set in commit prepared message](./end-lsn-is-not-set-in-commit-prepared-message.md)
- [end_lsn not set in begin prepare message](./end-lsn-not-set-in-begin-prepare-message.md)
