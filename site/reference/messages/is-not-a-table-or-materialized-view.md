---
message: "\"%s\" is not a table or materialized view"
slug: is-not-a-table-or-materialized-view
passthrough: false
api: [elog, ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/catalog/toasting.c:107"
  - "postgres/src/backend/commands/tablecmds.c:20217"
reproduced: true
---

# `"%s" is not a table or materialized view`

## What it means

A command that operates only on tables or materialized views was given another relation kind (such as a plain view, index, or sequence). The placeholder names the object.

## When it happens

It arises from operations restricted to tables and matviews — certain `ANALYZE`, statistics, or storage commands — when pointed at a relation of a different kind.

## How to fix

Name a table or materialized view, or use the command form appropriate to the object's kind. Check the type with `\d name`; for a plain view you generally cannot run table-storage operations.

## Example

*Reproduced* — captured from `reproducers/scenarios/29_func_index_extension_ddl.sql`.

```sql
CLUSTER repro.child_v;
```

Produces:

```text
ERROR:  "child_v" is not a table or materialized view
```

## Related

- [is a table](./is-a-table.md)
- [is not a foreign table](./is-not-a-foreign-table.md)
