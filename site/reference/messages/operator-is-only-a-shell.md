---
message: "operator is only a shell: %s"
slug: operator-is-only-a-shell
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/commands/operatorcmds.c:427"
  - "postgres/src/backend/parser/parse_oper.c:751"
  - "postgres/src/backend/parser/parse_oper.c:864"
reproduced: false
---

# `operator is only a shell: %s`

## What it means

A definition referenced an operator that exists only as a shell — a placeholder created to satisfy a mutual reference, with no implementation behind it yet. A shell operator has no function, so it cannot be used where a working operator is required.

## When it happens

Referencing an operator that was created as a forward declaration (for example to let two operators name each other as commutator or negator) but never completed with a backing function, or using such an operator in a query or an operator-class entry.

## How to fix

Complete the operator's definition so it has a function, or reference a fully defined operator instead. `CREATE OPERATOR` with the `PROCEDURE`/`FUNCTION` clause turns a shell into a real operator; until then the shell cannot be applied.

## Example

*Illustrative* — using an operator with no backing function.

```sql
SELECT 1 OPERATOR(public.===) 2;  -- === is only a shell
```

## Related

- [operator does not exist](./operator-does-not-exist-f067dc.md)
- [operator class does not exist for access method](./operator-class-does-not-exist-for-access-method.md)
