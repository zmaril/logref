---
message: "cannot fire deferred trigger within security-restricted operation"
slug: cannot-fire-deferred-trigger-within-security-restricted-operation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/commands/trigger.c:4716"
reproduced: false
---

# `cannot fire deferred trigger within security-restricted operation`

## What it means

A deferred constraint trigger came due while the backend was in a security-restricted operation. Postgres will not fire user triggers in that restricted context because they could run code as another role, so it refuses to fire the pending trigger.

## When it happens

It occurs when a maintenance operation or expression evaluation that runs in security-restricted mode reaches the point where deferred triggers must fire, for example at the end of a statement that touched a table with deferred constraints.

## How to fix

Do not defer constraint checks across a security-restricted operation. Set the relevant constraints to `IMMEDIATE`, or restructure the work so deferred triggers fire outside the restricted context.

## Example

*Illustrative* — a deferred trigger due in a restricted context.

```text
ERROR:  cannot fire deferred trigger within security-restricted operation
```

## Related

- [cannot execute within security-restricted operation](./cannot-execute-within-security-restricted-operation.md)
- [cannot execute within a background process](./cannot-execute-within-a-background-process.md)
