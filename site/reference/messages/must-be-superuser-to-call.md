---
message: "must be superuser to call %s()"
slug: must-be-superuser-to-call
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/catalog/catalog.c:687"
  - "postgres/src/backend/catalog/catalog.c:754"
reproduced: false
---

# `must be superuser to call %s()`

## What it means

A function that is restricted to superusers was called by a role that is not a superuser. The placeholder names the function.

## When it happens

It arises when a non-superuser calls a privileged built-in or extension function — for example certain server-file, replication, or diagnostic functions that require superuser rights.

## How to fix

Call the function as a superuser, or have a superuser grant a suitable path. Some restricted functions can be delegated by granting `EXECUTE` combined with a predefined role (such as `pg_read_server_files`); check whether a role grant covers your need instead of using a superuser directly.

## Example

*Illustrative* — a non-superuser calling a superuser-only function.

```sql
SELECT pg_some_superuser_only_func();  -- must be superuser to call
```

## Related

- [must be superuser to change data checksum state](./must-be-superuser-to-change-data-checksum-state.md)
- [only superuser can define a leakproof function](./only-superuser-can-define-a-leakproof-function.md)
