---
message: "relation \"%s.%s\" does not exist"
slug: relation-does-not-exist-7d5899
passthrough: false
api: [ereport]
level: [ERROR]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_UNDEFINED_TABLE
    code: "42P01"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:632"
  - "postgres/src/backend/parser/parse_relation.c:1469"
reproduced: false
---

# `relation "%s.%s" does not exist`

## What it means

A schema-qualified relation reference named a relation that does not exist. The placeholders are the schema and relation names. Unlike the search-path form, this variant reports both parts because the schema was given explicitly.

## When it happens

It arises when a statement references `schema.relation` and no such relation exists in that schema — a typo, a dropped object, or the object living in a different schema than assumed.

## How to fix

Confirm the schema and relation names (`\dt schema.*` in psql, or query `pg_class`/`information_schema.tables`). Correct the schema qualification, create the object if it is genuinely missing, or check that a migration created it where you expect.

## Example

*Illustrative* — a schema-qualified reference to a missing relation.

```text
ERROR:  relation "reporting.daily_totals" does not exist
```

## Related

- [relation "%s" already exists](./relation-already-exists.md)
- [referenced relation "%s" is not a table](./referenced-relation-is-not-a-table.md)
