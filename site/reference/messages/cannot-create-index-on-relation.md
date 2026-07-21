---
message: "cannot create index on relation \"%s\""
slug: cannot-create-index-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:724"
reproduced: false
---

# `cannot create index on relation "%s"`

## What it means

A `CREATE INDEX` named a relation whose kind cannot be indexed — for example a view, a composite type, or another object that has no physical rows to index. The placeholder is the relation name.

## When it happens

It occurs when `CREATE INDEX` targets a relation that is not an indexable table or materialized view.

## How to fix

Create indexes only on ordinary tables or materialized views. Point the `CREATE INDEX` at the base table that holds the data.

## Example

*Illustrative* — indexing a non-indexable relation.

```text
ERROR:  cannot create index on relation "v"
```

## Related

- [cannot create index on partitioned table concurrently](./cannot-create-index-on-partitioned-table-concurrently.md)
- [cannot create indexes on temporary tables of other sessions](./cannot-create-indexes-on-temporary-tables-of-other-sessions.md)
