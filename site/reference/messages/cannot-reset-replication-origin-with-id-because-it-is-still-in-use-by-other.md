---
message: "cannot reset replication origin with ID %d because it is still in use by other processes"
slug: cannot-reset-replication-origin-with-id-because-it-is-still-in-use-by-other
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/logical/origin.c:1318"
reproduced: false
---

# `cannot reset replication origin with ID %d because it is still in use by other processes`

## What it means

A `pg_replication_origin_session_reset()` or similar reset was refused because the replication origin is still attached to other processes. The origin cannot be reset while another backend has it set up. The placeholder is the origin id.

## When it happens

It occurs when a reset is attempted on a replication origin that a running apply worker or another session currently owns.

## How to fix

Stop the process using the origin first — disable the subscription or terminate the apply worker — then reset the origin. Confirm no other session has the origin set up before resetting it.

## Example

*Illustrative* — resetting an origin still in use.

```text
ERROR:  cannot reset replication origin with ID 3 because it is still in use by other processes
```

## Related

- [cannot setup replication origin when one is already setup](./cannot-setup-replication-origin-when-one-is-already-setup.md)
- [cannot query or manipulate replication origin when max_active_replication_origins is 0](./cannot-query-or-manipulate-replication-origin-when-max-active-replication.md)
