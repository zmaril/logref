---
message: "improper relation name (too many dotted names): %s"
slug: improper-relation-name-too-many-dotted-names
passthrough: false
api: [ereport, pg_fatal, pg_log_error]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:3645"
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:1447"
  - "postgres/src/bin/pg_dump/pg_dump.c:1855"
reproduced: false
---

# `improper relation name (too many dotted names): %s`

## What it means

A relation name was written with more dotted qualifiers than allowed. The placeholder is the offending name. A relation name may have at most three parts (`database.schema.table`, and cross-database references are not resolvable), so a name with too many dots cannot be interpreted.

## When it happens

Referencing a table with an over-qualified name — for example `a.b.c.d` — often a typo, a stray leading dot, or an attempt to reference another database's schema in a single name.

## How to fix

Use at most a schema-qualified name (`schema.table`), or a valid three-part form. Remove the extra qualifiers. PostgreSQL cannot reference tables in another database by name; to reach another database, connect to it or use a foreign-data wrapper.

## Example

*Illustrative* — an over-qualified relation name.

```sql
SELECT * FROM a.b.c.d;  -- improper relation name (too many dotted names)
```

## Related

- [name list length must be exactly](./name-list-length-must-be-exactly.md)
- [schema does not exist](./schema-does-not-exist.md)
