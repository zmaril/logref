---
message: "unexpected wait LSN type %d"
slug: unexpected-wait-lsn-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/wait.c:250"
  - "postgres/src/backend/commands/wait.c:294"
  - "postgres/src/backend/commands/wait.c:323"
reproduced: false
---

# `unexpected wait LSN type %d`

## What it means

Internal error. Code implementing the wait-for-log-position feature encountered a wait-type code it does not recognize. The message reports the numeric type. It is a consistency check on the wait machinery.

## When it happens

It should not occur through normal use of the wait feature. Reaching it points to an internal inconsistency rather than to your command as such.

## How to fix

Treat it as an internal bug. Capture the operation that triggered it and report it with the reported type value. There is no application-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — an unrecognized wait type.

```text
ERROR:  unexpected wait LSN type 3
```

## Related

- [wal start lsn must be less than current lsn](./wal-start-lsn-must-be-less-than-current-lsn.md)
- [unexpected termination of replication stream](./unexpected-termination-of-replication-stream.md)
