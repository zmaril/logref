---
message: "operator does not exist: %s"
slug: operator-does-not-exist-f067dc
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/commands/operatorcmds.c:419"
  - "postgres/src/backend/parser/parse_oper.c:120"
  - "postgres/src/backend/parser/parse_oper.c:648"
reproduced: true
---

# `operator does not exist: %s`

## What it means

A definition referenced an operator that does not exist. Unlike the query-time form that arises from type mismatches, this one comes from a command that names an operator directly, and no operator matches the given name and operand types.

## When it happens

Running `CREATE OPERATOR CLASS`, `ALTER OPERATOR FAMILY`, `CREATE OPERATOR` with a referenced operator, or a `COMMENT`/`DROP` on an operator, where the named operator and its operand types do not resolve to an existing operator.

## How to fix

Name an operator that exists, with its exact operand types. List operators with `\do` in psql, and include the argument types in the reference, since operators are identified by name plus both operand types. If the operator should exist, create it first.

## Example

*Reproduced* — captured from `reproducers/scenarios/21_ddl_objects.sql`.

```sql
DROP OPERATOR repro.+(int, int);
```

Produces:

```text
ERROR:  operator does not exist: integer repro.+ integer
```

## Related

- [operator is only a shell](./operator-is-only-a-shell.md)
- [operator does not exist](./operator-does-not-exist-1d7ffc.md)
