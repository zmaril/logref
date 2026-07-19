---
message: "bogus pg_index tuple"
slug: bogus-pg-index-tuple
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/relcache.c:1623"
reproduced: false
---

# `bogus pg_index tuple`

## What it means

Reading `pg_index`, the server found a row that is malformed or inconsistent for the index it describes. The `pg_index` catalog records each index's key columns and flags, and this entry did not make sense. It signals catalog corruption.

## When it happens

It is raised from index-metadata loading when `pg_index` data is damaged or internally inconsistent. It does not come from ordinary queries.

## How to fix

Treat this as catalog corruption for the affected index. Rebuild the index with `REINDEX` if possible, investigate storage and hardware, and restore from backup if catalog damage is widespread. Report it if the cause is unclear.

## Example

*Illustrative* — a malformed pg_index row.

```text
ERROR:  bogus pg_index tuple
```

## Related

- [bogus pg_inherit row inhrelid inhparent](./bogus-pg-inherit-row-inhrelid-inhparent.md)
- [atttypid is invalid for non-dropped column](./atttypid-is-invalid-for-non-dropped-column-in.md)
