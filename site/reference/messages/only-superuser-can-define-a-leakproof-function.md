---
message: "only superuser can define a leakproof function"
slug: only-superuser-can-define-a-leakproof-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:1151"
  - "postgres/src/backend/commands/functioncmds.c:1438"
reproduced: false
---

# `only superuser can define a leakproof function`

## What it means

A non-superuser tried to mark a function `LEAKPROOF`. The leakproof property affects security decisions around row-level security, so only superusers may set it.

## When it happens

It arises from `CREATE FUNCTION ... LEAKPROOF` or `ALTER FUNCTION ... LEAKPROOF` run by a role without superuser privilege.

## How to fix

Define or alter the leakproof property as a superuser. Only mark a function `LEAKPROOF` if it genuinely cannot leak information about its arguments through errors or timing, since the planner relies on that guarantee.

## Example

*Illustrative* — a non-superuser setting LEAKPROOF.

```sql
ALTER FUNCTION f(int) LEAKPROOF;  -- only superuser may set this
```

## Related

- [must be superuser to call](./must-be-superuser-to-call.md)
- [invalid attribute in procedure definition](./invalid-attribute-in-procedure-definition.md)
