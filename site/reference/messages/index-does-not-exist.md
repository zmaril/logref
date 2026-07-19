---
message: "index \"%s\" does not exist"
slug: index-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:22393"
  - "postgres/src/backend/parser/parse_utilcmd.c:2432"
reproduced: false
---

# `index "%s" does not exist`

## What it means

A command referenced an index by name, but no index with that name exists in the search path or the schema given.

## When it happens

It happens on `ALTER INDEX`, `DROP INDEX`, `REINDEX INDEX`, `CLUSTER`, or `COMMENT ON INDEX` when the index name is misspelled, was already dropped, or lives in a schema that is not on the search path.

## How to fix

Verify the index name and schema with `\di` in psql, or query `pg_indexes`. Use `DROP INDEX IF EXISTS` when the index may already be gone. Qualify the name with its schema if it is not on the current `search_path`.

## Example

*Illustrative* — dropping an index that is not present.

```sql
DROP INDEX no_such_idx;  -- index does not exist
```

## Related

- [index does not belong to table](./index-does-not-belong-to-table.md)
- [index was concurrently dropped](./index-was-concurrently-dropped.md)
