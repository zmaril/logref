---
message: "procedure %s does not exist"
slug: procedure-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/parser/parse_func.c:640"
  - "postgres/src/backend/parser/parse_func.c:2541"
reproduced: true
---

# `procedure %s does not exist`

## What it means

A `CALL` (or a procedure-referencing command) named a procedure that does not exist with the given name and argument types. The placeholder shows the procedure signature that could not be resolved.

## When it happens

It arises from `CALL proc(...)` when the name is misspelled, the argument types do not match any procedure, the procedure is in a schema not on the search path, or you referenced a function where a procedure is required.

## How to fix

Verify the procedure exists and its argument types with `\df proc` in psql or by querying `pg_proc` (where `prokind = 'p'`). Schema-qualify the call if needed, and match the argument types — a `CALL` will not silently resolve to a function.

## Example

*Reproduced* — captured from `reproducers/scenarios/26_roles_acl_plpgsql.sql`.

```sql
CALL repro.pr(1);
```

Produces:

```text
ERROR:  procedure repro.pr(integer) does not exist
```

## Related

- [property graph "%s" has no element with alias "%s"](./property-graph-has-no-element-with-alias.md)
- [query for CALL statement is not a CallStmt](./query-for-call-statement-is-not-a-callstmt.md)
