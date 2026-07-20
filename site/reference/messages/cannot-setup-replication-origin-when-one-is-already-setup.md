---
message: "cannot setup replication origin when one is already setup"
slug: cannot-setup-replication-origin-when-one-is-already-setup
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/logical/origin.c:1171"
reproduced: false
---

# `cannot setup replication origin when one is already setup`

## What it means

A replication-origin setup was requested while the session already has an origin set up. A session can have only one active replication origin at a time, so a second setup is rejected.

## When it happens

It occurs when `pg_replication_origin_session_setup()` is called twice without a reset in between, or an apply worker attempts to set up an origin while one is active.

## How to fix

Reset the current origin with `pg_replication_origin_session_reset()` before setting up another, or ensure only one origin is configured per session. Pair each setup with a reset.

## Example

*Illustrative* — a second origin setup in one session.

```text
ERROR:  cannot setup replication origin when one is already setup
```

## Related

- [cannot reset replication origin with ID because it is still in use by other processes](./cannot-reset-replication-origin-with-id-because-it-is-still-in-use-by-other.md)
- [cannot query or manipulate replication origin when max_active_replication_origins is 0](./cannot-query-or-manipulate-replication-origin-when-max-active-replication.md)
