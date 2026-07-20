---
message: "\"%s\" is not an index"
slug: is-not-an-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/access/index/indexam.c:202"
  - "postgres/src/backend/catalog/objectaddress.c:1453"
  - "postgres/src/backend/commands/indexcmds.c:3162"
  - "postgres/src/backend/commands/tablecmds.c:20406"
  - "postgres/src/backend/commands/tablecmds.c:22350"
reproduced: false
---

# `"%s" is not an index`

## What it means

A command that requires an index was given an object that is not one. The placeholder is the object name. Operations like `REINDEX INDEX`, `ALTER INDEX`, or index-only inspection paths only accept index relations.

## When it happens

Running an index-only command on a table, view, sequence, or other non-index relation — for example `ALTER INDEX t ...` where `t` is a table, or attaching a non-index as an index partition.

## How to fix

Check the object's kind with `\d name`. Use the table-oriented command (`ALTER TABLE`, `REINDEX TABLE`) for a table, or name an actual index. Correct the object name if it was a mistake.

## Example

*Illustrative* — a table passed to an index command.

```sql
ALTER INDEX my_table SET (fillfactor = 70);
```

## Related

- [is not a index](./is-not-a-index.md)
- [cannot attach index as a partition of index](./cannot-attach-index-as-a-partition-of-index.md)
