---
message: "cannot create a cursor WITH HOLD within security-restricted operation"
slug: cannot-create-a-cursor-with-hold-within-security-restricted-operation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/commands/portalcmds.c:73"
reproduced: false
---

# `cannot create a cursor WITH HOLD within security-restricted operation`

## What it means

Code running in a security-restricted context tried to declare a `CURSOR ... WITH HOLD`. A holdable cursor survives past the current transaction, which is not allowed inside a security-restricted operation such as index maintenance or a `SECURITY DEFINER` setup step.

## When it happens

It occurs when a `WITH HOLD` cursor is declared from within a routine or operation that runs under security restrictions.

## How to fix

Declare a non-holdable cursor inside that context, or move the holdable-cursor logic outside the security-restricted operation. A cursor that must outlive the transaction cannot be created there.

## Example

*Illustrative* — a WITH HOLD cursor in a restricted context.

```text
ERROR:  cannot create a cursor WITH HOLD within security-restricted operation
```

## Related

- [cannot create temporary table within security-restricted operation](./cannot-create-temporary-table-within-security-restricted-operation.md)
- [cannot drop active portal](./cannot-drop-active-portal.md)
