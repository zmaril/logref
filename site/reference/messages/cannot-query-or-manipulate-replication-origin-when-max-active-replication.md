---
message: "cannot query or manipulate replication origin when \"max_active_replication_origins\" is 0"
slug: cannot-query-or-manipulate-replication-origin-when-max-active-replication
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/logical/origin.c:210"
reproduced: false
---

# `cannot query or manipulate replication origin when "max_active_replication_origins" is 0`

## What it means

A replication-origin function was called while `max_active_replication_origins` is set to 0. That setting disables the replication-origin subsystem entirely, so no origin can be queried or changed.

## When it happens

It occurs when logical-replication or a tool calls a replication-origin function on a server configured with `max_active_replication_origins = 0`.

## How to fix

Set `max_active_replication_origins` to a value large enough for your replication topology and restart the server, then retry. The origin subsystem needs a non-zero slot count to operate.

## Example

*Illustrative* — origin function with the subsystem disabled.

```text
ERROR:  cannot query or manipulate replication origin when "max_active_replication_origins" is 0
```

## Related

- [cannot manipulate replication origins during recovery](./cannot-manipulate-replication-origins-during-recovery.md)
- [cannot reset replication origin with ID because it is still in use by other processes](./cannot-reset-replication-origin-with-id-because-it-is-still-in-use-by-other.md)
