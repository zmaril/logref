---
message: "cannot create temporary relation in non-temporary schema"
slug: cannot-create-temporary-relation-in-non-temporary-schema
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:859"
  - "postgres/src/backend/parser/parse_utilcmd.c:4592"
reproduced: false
---

# `cannot create temporary relation in non-temporary schema`

## What it means

A `CREATE TEMP` object was schema-qualified with a schema that is not a temporary schema. Temporary relations must live in the session's temporary schema; naming a regular schema for a temp object is contradictory.

## When it happens

Writing `CREATE TEMP TABLE public.t (...)` or otherwise qualifying a temporary relation with an ordinary (non-temporary) schema name.

## How to fix

Drop the schema qualification from the `CREATE TEMP` statement and let Postgres place the object in `pg_temp`, or remove `TEMP` if you actually want a permanent table in that schema. A temporary object cannot be forced into a permanent schema.

## Example

*Illustrative* — a temp table qualified with a real schema.

```sql
CREATE TEMP TABLE public.t (id int);
-- ERROR:  cannot create temporary relation in non-temporary schema
```

## Related

- [cannot create relations in temporary schemas of other sessions](./cannot-create-relations-in-temporary-schemas-of-other-sessions.md)
- [cannot create a temporary relation as partition of permanent relation](./cannot-create-a-temporary-relation-as-partition-of-permanent-relation.md)
