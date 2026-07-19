---
message: "cannot start logical replication workers when \"max_active_replication_origins\" is 0"
slug: cannot-start-logical-replication-workers-when-max-active-replication-origins-is
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONFIGURATION_LIMIT_EXCEEDED
    code: "53400"
call_sites:
  - "postgres/src/backend/replication/logical/launcher.c:371"
reproduced: false
---

# `cannot start logical replication workers when "max_active_replication_origins" is 0`

## What it means

Logical replication needs replication origins to track apply progress, but `max_active_replication_origins` is set to zero. With no origin slots available, apply workers cannot start.

## When it happens

It occurs when a subscription is enabled or the apply worker tries to launch while `max_active_replication_origins` is `0` on the subscriber.

## How to fix

Raise `max_active_replication_origins` in `postgresql.conf` to at least the number of subscriptions you expect, then restart the server so the change takes effect.

## Example

*Illustrative* — origins disabled on the subscriber.

```text
ERROR:  cannot start logical replication workers when "max_active_replication_origins" is 0
```

## Related

- [cannot use PID for inactive replication origin with ID](./cannot-use-pid-for-inactive-replication-origin-with-id.md)
- [cannot synchronize local slot](./cannot-synchronize-local-slot.md)
