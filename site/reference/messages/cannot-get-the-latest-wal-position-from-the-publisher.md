---
message: "cannot get the latest WAL position from the publisher"
slug: cannot-get-the-latest-wal-position-from-the-publisher
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/worker.c:4152"
reproduced: false
---

# `cannot get the latest WAL position from the publisher`

## What it means

An internal guard in the logical-replication apply worker fired: it could not obtain the latest WAL position from the publisher when it needed one. The apply worker relies on that position to coordinate progress, and the value was unavailable at this point.

## When it happens

It is reached inside the apply worker's coordination logic when the expected WAL position from the publisher is missing. It reflects an internal sequencing issue rather than a routine connectivity failure.

## How to fix

There is no user-level fix. If it recurs, capture the subscription configuration and the publisher and subscriber logs and report it. Confirm the replication connection is otherwise healthy so the issue is not masked by an unrelated network fault.

## Example

*Illustrative* — the publisher WAL position unavailable.

```text
ERROR:  cannot get the latest WAL position from the publisher
```

## Related

- [cannot manipulate replication origins during recovery](./cannot-manipulate-replication-origins-during-recovery.md)
- [cannot initialize logical decoding without a specified plugin](./cannot-initialize-logical-decoding-without-a-specified-plugin.md)
