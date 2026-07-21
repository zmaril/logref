---
message: "\"%s\" is not a view"
slug: is-not-a-view-960471
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:1482"
  - "postgres/src/backend/commands/tablecmds.c:20379"
  - "postgres/src/backend/commands/view.c:110"
reproduced: false
---

# `"%s" is not a view`

## What it means

A command that operates on views was pointed at a relation that is not a view. `CREATE OR REPLACE VIEW`, `ALTER VIEW`, and related operations require the target to be a view, and the named object is a table or another relation kind.

## When it happens

Running `ALTER VIEW`, `CREATE OR REPLACE VIEW` over an existing name, or another view-only command against a name that resolves to a table.

## How to fix

Confirm the object is a view (`\dv` in psql). If you meant a table, use `ALTER TABLE`. `CREATE OR REPLACE VIEW` cannot replace a table, so choose a new name or drop the table first if a view is what you intend.

## Example

*Illustrative* — altering a table as a view.

```sql
ALTER VIEW orders ALTER COLUMN id SET DEFAULT 0;  -- "orders" is not a view
```

## Related

- [is a view](./is-a-view.md)
- [is not a materialized view](./is-not-a-materialized-view.md)
