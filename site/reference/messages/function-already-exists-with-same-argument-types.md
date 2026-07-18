---
message: "function \"%s\" already exists with same argument types"
slug: function-already-exists-with-same-argument-types
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_FUNCTION
    code: "42723"
call_sites:
  - "postgres/src/backend/catalog/pg_proc.c:402"
reproduced: true
---

# `function "%s" already exists with same argument types`

## What it means

A `CREATE FUNCTION` collided with an existing function of the same name and the same argument type list. Postgres identifies functions by name plus argument types (overloading), so this specific signature is already defined.

## When it happens

Defining a function that already exists with an identical signature, or re-running a migration that creates it. Changing only the return type, parameter names, or body does not make a new signature — the argument types are what count.

## How to fix

Use `CREATE OR REPLACE FUNCTION` to redefine the body in place; that is the intended path for updating a function. If you meant a distinct function, change the argument types so the signature differs, or rename it. To remove the old one first, `DROP FUNCTION name(argtypes)` — the argument types are required to disambiguate overloads.

## Example

*Reproduced* — The DDL-duplicate reproducer scenario redefines an existing function (`06_ddl_duplicate.sql`).

```sql
CREATE FUNCTION addone(int) RETURNS int LANGUAGE sql AS 'SELECT $1 + 1';
CREATE FUNCTION addone(int) RETURNS int LANGUAGE sql AS 'SELECT 1';
```

Produces:

```text
ERROR:  function "addone" already exists with same argument types
```

## Related

- [relation "%s" already exists](./relation-already-exists.md)
