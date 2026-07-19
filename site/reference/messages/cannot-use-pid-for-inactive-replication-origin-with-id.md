---
message: "cannot use PID %d for inactive replication origin with ID %d"
slug: cannot-use-pid-for-inactive-replication-origin-with-id
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/logical/origin.c:1249"
reproduced: false
---

# `cannot use PID %d for inactive replication origin with ID %d`

## What it means

A call tried to attach a process to a replication origin that is marked inactive. Only an active origin can be claimed by a backend, so associating a PID with an inactive one is rejected.

## When it happens

It occurs during replication-origin setup, for example `pg_replication_origin_session_setup()`, when the named origin is not in an active state.

## How to fix

Activate or recreate the replication origin before attaching to it, and confirm no other session already holds it. Check origin state with `pg_replication_origin_status`.

## Example

*Illustrative* — attaching to an inactive origin.

```text
ERROR:  cannot use PID 4321 for inactive replication origin with ID 3
```

## Related

- [cannot start logical replication workers when max_active_replication_origins is 0](./cannot-start-logical-replication-workers-when-max-active-replication-origins-is.md)
- [cannot synchronize local slot](./cannot-synchronize-local-slot.md)
