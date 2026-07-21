---
message: "cannot attach index \"%s\" as a partition of index \"%s\""
slug: cannot-attach-index-as-a-partition-of-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:22430"
  - "postgres/src/backend/commands/tablecmds.c:22450"
  - "postgres/src/backend/commands/tablecmds.c:22471"
  - "postgres/src/backend/commands/tablecmds.c:22490"
  - "postgres/src/backend/commands/tablecmds.c:22547"
reproduced: false
---

# `cannot attach index "%s" as a partition of index "%s"`

## What it means

`ALTER INDEX ... ATTACH PARTITION` was refused because the child index does not match the parent partitioned index. The placeholders are the child and parent index names. To attach, the child must correspond exactly to the parent's definition on the matching table partition.

## When it happens

Attaching an index to a partitioned index when the two differ in column set, expression, opclass, collation, or uniqueness, or when the child is not an index on the correct partition of the parent's table.

## How to fix

Build the child index to match the parent's definition exactly — same columns/expressions in the same order, same operator classes and collations, and on the right table partition — then attach it. In most cases it is simpler to let `CREATE INDEX` on the partitioned parent create and attach child indexes automatically.

## Example

*Illustrative* — attaching a mismatched index.

```sql
ALTER INDEX parent_idx ATTACH PARTITION child_idx;
```

## Related

- [is not an index](./is-not-an-index.md)
- [constraint of relation does not exist](./constraint-of-relation-does-not-exist.md)
