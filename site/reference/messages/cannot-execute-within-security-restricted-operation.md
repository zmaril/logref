---
message: "cannot execute %s within security-restricted operation"
slug: cannot-execute-within-security-restricted-operation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/tcop/utility.c:467"
reproduced: false
---

# `cannot execute %s within security-restricted operation`

## What it means

A command was blocked because it ran inside a security-restricted operation. Postgres enters this restricted mode when it must run code on behalf of another role — for example while computing an index expression or a maintenance function — and forbids commands that could be exploited to change privileges. The placeholder is the command name.

## When it happens

It occurs when a function invoked during index maintenance, `VACUUM`, `ANALYZE`, `REFRESH MATERIALIZED VIEW`, or a similar operation tries to run a command that the restricted context disallows.

## How to fix

Remove the disallowed command from the function that runs in the restricted context. Move side-effecting work out of expressions and maintenance callbacks so they perform only safe computation.

## Example

*Illustrative* — a command inside a restricted operation.

```text
ERROR:  cannot execute SET in a security-restricted operation
```

## Related

- [cannot fire deferred trigger within security-restricted operation](./cannot-fire-deferred-trigger-within-security-restricted-operation.md)
- [cannot execute within a background process](./cannot-execute-within-a-background-process.md)
