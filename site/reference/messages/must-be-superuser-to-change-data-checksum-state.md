---
message: "must be superuser to change data checksum state"
slug: must-be-superuser-to-change-data-checksum-state
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/postmaster/datachecksum_state.c:549"
  - "postgres/src/backend/postmaster/datachecksum_state.c:571"
reproduced: false
---

# `must be superuser to change data checksum state`

## What it means

Enabling or disabling data checksums on a running cluster requires superuser privileges, and the calling role is not a superuser.

## When it happens

It arises when a non-superuser invokes the online checksum-control functions to turn data checksums on or off.

## How to fix

Perform the checksum change as a superuser. Data checksums affect the whole cluster's on-disk format, so the operation is restricted; coordinate it with an administrator.

## Example

*Illustrative* — a non-superuser changing checksum state.

```sql
SELECT pg_enable_data_checksums();  -- must be superuser
```

## Related

- [must be superuser to call](./must-be-superuser-to-call.md)
- [only superuser can define a leakproof function](./only-superuser-can-define-a-leakproof-function.md)
