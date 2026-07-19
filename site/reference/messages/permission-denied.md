---
message: "permission denied"
slug: permission-denied
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:2622"
  - "postgres/src/backend/catalog/objectaddress.c:2631"
  - "postgres/src/backend/catalog/objectaddress.c:2637"
reproduced: false
---

# `permission denied`

## What it means

The current role lacks the privilege required for the operation. This is the bare form of the privilege error, used where the specific object is reported separately or the check is a general one on an object the role may not access.

## When it happens

Attempting an action the role has not been granted — reading or writing an object, calling a function, or using a schema — without the necessary privilege, membership, or ownership.

## How to fix

Grant the missing privilege to the role, or run the action as a role that already holds it. Identify what the operation requires (for example `SELECT`, `USAGE`, or ownership) and use `GRANT` to provide it, or adjust role membership. Overly broad grants weaken security, so grant the narrowest privilege that suffices.

## Example

*Illustrative* — an action the role is not allowed to perform.

```sql
SELECT * FROM restricted_object;  -- permission denied
```

## Related

- [permission denied to examine](./permission-denied-to-examine.md)
- [permission denied to cancel query](./permission-denied-to-cancel-query.md)
