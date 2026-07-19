---
message: "no replication origin is configured"
slug: no-replication-origin-is-configured
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/logical/origin.c:1306"
  - "postgres/src/backend/replication/logical/origin.c:1542"
  - "postgres/src/backend/replication/logical/origin.c:1562"
reproduced: false
---

# `no replication origin is configured`

## What it means

An operation that records or advances a replication origin was run without a replication origin set up for the current session. Replication origins track how far replayed data has progressed, and none was established.

## When it happens

Calling replication-origin functions such as advancing or reporting the session's origin before selecting one with `pg_replication_origin_session_setup`, or using an apply path that expects an origin that was never configured.

## How to fix

Set up the replication origin for the session before recording progress against it. Create the origin if needed and attach it with the session-setup function, then perform the origin-dependent operation.

## Example

*Illustrative* — advancing an origin that was never configured.

```sql
SELECT pg_replication_origin_session_progress(true);  -- no origin set up first
```

## Related

- [cache lookup failed for replication origin with id](./cache-lookup-failed-for-replication-origin-with-id.md)
- [no replication origin is configured](./no-replication-origin-is-configured.md)
