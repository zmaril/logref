---
message: "unrecognized flags %u in commit message"
slug: unrecognized-flags-in-commit-message
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/proto.c:104"
  - "postgres/src/backend/replication/logical/proto.c:1143"
reproduced: false
---

# `unrecognized flags %u in commit message`

## What it means

Internal error. WAL replay of a transaction-commit record found flag bits in the record that this server version does not define.

## When it happens

It fires during recovery/decoding when a commit record's flags include unknown bits — usually WAL written by a newer major version, or a corrupt record.

## How to fix

This is a guard over WAL contents. Do not replay WAL from a newer major version on an older server; if the WAL is from a matching version and this appears, the record may be corrupt — investigate storage and report it.

## Example

*Illustrative* — unknown flags in a commit record.

```text
ERROR:  unrecognized flags 128 in commit message
```

## Related

- [unexpected WAL source %d](./unexpected-wal-source.md)
- [unrecognized streaming header: "%c"](./unrecognized-streaming-header.md)
