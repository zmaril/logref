---
message: "no schema has been selected to create in"
slug: no-schema-has-been-selected-to-create-in
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_SCHEMA
    code: "3F000"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:703"
  - "postgres/src/backend/catalog/namespace.c:3592"
  - "postgres/src/backend/commands/extension.c:1986"
  - "postgres/src/backend/commands/extension.c:1992"
reproduced: false
---

# `no schema has been selected to create in`

## What it means

An object was created with an unqualified name, but there is no schema in which to place it: the `search_path` is empty or names only schemas that do not exist or are not visible to the current role. Postgres creates unqualified objects in the first usable schema of `search_path`, and here there is none.

## When it happens

Running a `CREATE TABLE foo` (or any create with an unqualified name) after `search_path` was set to something empty or invalid, or when every schema in the path has been dropped or is not accessible to the current user.

## How to fix

Either schema-qualify the new object (`CREATE TABLE myschema.foo`) or set a `search_path` that contains a schema the role can create in — `SET search_path TO public;` if `public` exists and is writable. Confirm the target schema exists (`\dn`) and that the role holds `CREATE` on it.

## Example

*Illustrative* — creating into an empty search_path.

```sql
SET search_path TO '';
CREATE TABLE foo (id int);  -- no schema has been selected to create in
```

## Related

- [schema does not exist](./schema-does-not-exist.md)
- [permission denied to set parameter](./permission-denied-to-set-parameter.md)
