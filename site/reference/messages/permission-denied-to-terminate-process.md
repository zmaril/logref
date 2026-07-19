---
message: "permission denied to terminate process"
slug: permission-denied-to-terminate-process
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/storage/ipc/procarray.c:3899"
  - "postgres/src/backend/storage/ipc/procarray.c:3907"
  - "postgres/src/backend/storage/ipc/signalfuncs.c:252"
  - "postgres/src/backend/storage/ipc/signalfuncs.c:259"
  - "postgres/src/backend/storage/ipc/signalfuncs.c:266"
reproduced: false
---

# `permission denied to terminate process`

## What it means

A call to terminate (or cancel) another backend was refused because the current role is not permitted to signal that process. The placeholder-free text covers `pg_terminate_backend`/`pg_cancel_backend`. A role may signal only its own backends unless it has been granted broader rights.

## When it happens

Calling `pg_terminate_backend(pid)` or `pg_cancel_backend(pid)` against a session owned by another role, without superuser status or membership in a role that permits it.

## How to fix

Signal only your own sessions, or obtain the needed rights: superusers may signal anyone, and membership in `pg_signal_backend` allows signaling non-superuser backends. To manage another role's sessions, grant membership in that role or in `pg_signal_backend`.

## Example

*Illustrative* — terminating another role's backend.

```sql
SELECT pg_terminate_backend(12345);
```

## Related

- [permission denied to create role](./permission-denied-to-create-role.md)
- [could not obtain lock on row in relation](./could-not-obtain-lock-on-row-in-relation.md)
