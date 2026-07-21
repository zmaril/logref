---
message: "cannot create relations in temporary schemas of other sessions"
slug: cannot-create-relations-in-temporary-schemas-of-other-sessions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:855"
  - "postgres/src/backend/catalog/namespace.c:868"
reproduced: false
---

# `cannot create relations in temporary schemas of other sessions`

## What it means

A command tried to create an object in the temporary schema belonging to a different session. Each session's temporary schema (`pg_temp_NNN`) is private to that session; another session cannot create relations inside it.

## When it happens

Explicitly schema-qualifying a `CREATE` with another backend's `pg_temp_NNN` schema name, usually from generated SQL that captured a specific temp-schema name rather than the session-local `pg_temp` alias.

## How to fix

Create temporary objects with `CREATE TEMP TABLE` or under the `pg_temp` alias, which always resolves to your own session's temporary schema. Never hard-code another session's numbered temp schema name.

## Example

*Illustrative* — creating in another session's temp schema.

```sql
CREATE TABLE pg_temp_3.t (id int);
-- ERROR:  cannot create relations in temporary schemas of other sessions
```

## Related

- [cannot create temporary relation in non-temporary schema](./cannot-create-temporary-relation-in-non-temporary-schema.md)
- [cannot execute on temporary tables of other sessions](./cannot-execute-on-temporary-tables-of-other-sessions.md)
