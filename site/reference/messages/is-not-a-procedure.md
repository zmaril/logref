---
message: "%s is not a procedure"
slug: is-not-a-procedure
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/parser/parse_func.c:290"
  - "postgres/src/backend/parser/parse_func.c:2498"
reproduced: true
---

# `%s is not a procedure`

## What it means

`CALL` (or a procedure-specific command) named a routine that is a function, not a procedure. The placeholder identifies the routine. `CALL` only invokes procedures.

## When it happens

It arises when using `CALL name(...)` on a function, or `ALTER/DROP PROCEDURE` on a function, when the routine was created with `CREATE FUNCTION` rather than `CREATE PROCEDURE`.

## How to fix

Invoke functions with `SELECT function(...)` and procedures with `CALL procedure(...)`. If you intended a procedure, create it with `CREATE PROCEDURE`. Use `\df` to see whether a routine is a function or a procedure.

## Example

*Reproduced* — captured from `reproducers/scenarios/26_roles_acl_plpgsql.sql`.

```sql
CALL repro.addone(1);
```

Produces:

```text
ERROR:  repro.addone(integer) is not a procedure
```

## Related

- [is not a base type](./is-not-a-base-type.md)
- [invalid attribute in procedure definition](./invalid-attribute-in-procedure-definition.md)
