---
message: "index \"%s\" for table \"%s\" does not exist"
slug: index-for-table-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/repack.c:2508"
  - "postgres/src/backend/commands/tablecmds.c:17161"
  - "postgres/src/backend/commands/tablecmds.c:19224"
reproduced: true
---

# `index "%s" for table "%s" does not exist`

## What it means

A command named an index on a specific table, and no index by that name belongs to that table. The name may exist elsewhere in the database, but not as an index of the table the command is operating on.

## When it happens

Running `ALTER TABLE ... CLUSTER ON`, `REINDEX`, `REPACK`, or a similar command that references an index by name, when the name is misspelled, was dropped, belongs to a different table, or lives in another schema than the one the search path resolves to.

## How to fix

Check the actual index names on the table with `\d tablename` in psql, or query `pg_indexes` for the schema and table. Use the exact index name, schema-qualify it if the search path is ambiguous, and confirm the index was not dropped by an earlier migration.

## Example

*Reproduced* — captured from `reproducers/scenarios/29_func_index_extension_ddl.sql`.

```sql
CLUSTER repro.parent USING nonexistent_idx;
```

Produces:

```text
ERROR:  index "nonexistent_idx" for table "parent" does not exist
```

## Related

- [trigger for table does not exist](./trigger-for-table-does-not-exist.md)
- [policy for table does not exist](./policy-for-table-does-not-exist.md)
