---
message: "cannot reindex partitioned index \"%s.%s\""
slug: cannot-reindex-partitioned-index
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/index.c:3739"
reproduced: false
---

# `cannot reindex partitioned index "%s.%s"`

## What it means

An internal guard fired: low-level index code was asked to reindex a partitioned index directly. A partitioned index is a catalog-only parent with no storage of its own, so there is nothing to rebuild at that level. The placeholders are the schema and index names.

## When it happens

It is reached when reindex machinery reaches a partitioned index parent rather than its leaf indexes. The user-facing `REINDEX` command handles this by recursing to the leaves, so reaching the guard reflects an internal path issue.

## How to fix

There is no user-level fix at this guard. Run `REINDEX INDEX` on the partitioned index through the normal command, which reindexes each leaf partition. If it appears from a tool or extension, report it.

## Example

*Illustrative* — reindexing a partitioned index parent.

```text
ERROR:  cannot reindex partitioned index "public.orders_pkey"
```

## Related

- [cannot reindex partitioned table](./cannot-reindex-partitioned-table.md)
- [cannot reindex this type of relation concurrently](./cannot-reindex-this-type-of-relation-concurrently.md)
