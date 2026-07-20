---
message: "cannot change owner of index \"%s\""
slug: cannot-change-owner-of-index
passthrough: false
api: [ereport]
level: [ERROR, WARNING]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:16820"
  - "postgres/src/backend/commands/tablecmds.c:16832"
reproduced: false
---

# `cannot change owner of index "%s"`

## What it means

A command tried to change the owner of an index directly. The placeholder is the index name. An index is owned implicitly by its table, so its ownership cannot be set on its own.

## When it happens

Running `ALTER INDEX ... OWNER TO`, or a `REASSIGN OWNED` that reaches an index directly rather than through its table.

## How to fix

Change the owner of the underlying table instead; the index follows it. Use `ALTER TABLE ... OWNER TO` on the parent table. Indexes never carry an owner independent of their table.

## Example

*Illustrative* — reassigning an index's owner.

```sql
ALTER INDEX t_pkey OWNER TO alice;
-- ERROR:  cannot change owner of index "t_pkey"
```

## Related

- [cannot change routine kind](./cannot-change-routine-kind.md)
- [cannot create unique index on partitioned table](./cannot-create-unique-index-on-partitioned-table.md)
