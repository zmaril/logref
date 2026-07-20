---
message: "permission denied to cancel query"
slug: permission-denied-to-cancel-query
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/storage/ipc/signalfuncs.c:139"
  - "postgres/src/backend/storage/ipc/signalfuncs.c:146"
  - "postgres/src/backend/storage/ipc/signalfuncs.c:153"
reproduced: false
---

# `permission denied to cancel query`

## What it means

A role tried to cancel or terminate another backend's query without the authority to do so. Cancelling another session's work requires that the requester own that session's role or hold a privilege that permits it.

## When it happens

Calling `pg_cancel_backend` or `pg_terminate_backend` against a backend belonging to a different role, without membership in that role or the built-in role that grants signal privileges.

## How to fix

Run the cancellation as a role permitted to signal the target — the same role, a role it belongs to, or a superuser. Membership in `pg_signal_backend` lets a role cancel non-superuser backends; grant that membership if the ability is needed regularly.

## Example

*Illustrative* — cancelling another role's backend without rights.

```sql
SELECT pg_cancel_backend(12345);  -- backend owned by another role
```

## Related

- [permission denied](./permission-denied.md)
- [could not send signal to process](./could-not-send-signal-to-process.md)
