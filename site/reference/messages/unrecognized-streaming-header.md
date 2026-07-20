---
message: "unrecognized streaming header: \"%c\""
slug: unrecognized-streaming-header
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:518"
  - "postgres/src/bin/pg_basebackup/receivelog.c:853"
reproduced: false
---

# `unrecognized streaming header: "%c"`

## What it means

Internal error. A logical-replication apply worker reading the streaming protocol met a message-header byte it does not recognize.

## When it happens

It fires on the subscriber when the stream from the publisher contains a header outside the known set — usually a protocol-version mismatch or a desynchronized stream.

## How to fix

This is a guard over the logical-replication stream. Confirm publisher and subscriber are compatible versions; if they are and it recurs, the stream may be corrupt — capture the subscription and report it.

## Example

*Illustrative* — an unrecognized streaming header.

```text
ERROR:  unrecognized streaming header: "Z"
```

## Related

- [unrecognized origin value: "%s"](./unrecognized-origin-value.md)
- [unrecognized flags %u in commit message](./unrecognized-flags-in-commit-message.md)
