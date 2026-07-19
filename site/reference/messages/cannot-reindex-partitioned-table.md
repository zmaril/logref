---
message: "cannot reindex partitioned table \"%s.%s\""
slug: cannot-reindex-partitioned-table
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/index.c:3999"
reproduced: false
---

# `cannot reindex partitioned table "%s.%s"`

## What it means

An internal guard fired: low-level index code was asked to reindex a partitioned table directly. A partitioned table is a catalog-only parent with no storage of its own, so it has no indexes to rebuild at that level. The placeholders are the schema and table names.

## When it happens

It is reached when reindex machinery reaches a partitioned table parent rather than its leaf partitions. The `REINDEX` command normally recurses to the leaves, so hitting the guard reflects an internal path issue.

## How to fix

There is no user-level fix at this guard. Run `REINDEX TABLE` on the partitioned table through the normal command, which reindexes each leaf partition. If it appears from a tool or extension, report it.

## Example

*Illustrative* — reindexing a partitioned table parent.

```text
ERROR:  cannot reindex partitioned table "public.orders"
```

## Related

- [cannot reindex partitioned index](./cannot-reindex-partitioned-index.md)
- [cannot reindex this type of relation concurrently](./cannot-reindex-this-type-of-relation-concurrently.md)
