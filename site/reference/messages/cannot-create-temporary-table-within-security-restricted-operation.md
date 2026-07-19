---
message: "cannot create temporary table within security-restricted operation"
slug: cannot-create-temporary-table-within-security-restricted-operation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:892"
reproduced: false
---

# `cannot create temporary table within security-restricted operation`

## What it means

Code running in a security-restricted context tried to create a temporary table. Temporary-table creation is not permitted inside a security-restricted operation, such as index maintenance or a `SECURITY DEFINER` setup step, because it could be used to influence later code.

## When it happens

It occurs when a `CREATE TEMP TABLE` runs from within a routine or operation executing under security restrictions.

## How to fix

Move temporary-table creation outside the security-restricted operation. Restructure the routine so any temporary tables are created in an ordinary, unrestricted context.

## Example

*Illustrative* — a temp table in a restricted context.

```text
ERROR:  cannot create temporary table within security-restricted operation
```

## Related

- [cannot create a cursor with hold within security-restricted operation](./cannot-create-a-cursor-with-hold-within-security-restricted-operation.md)
- [cannot create temporary tables during a parallel operation](./cannot-create-temporary-tables-during-a-parallel-operation.md)
