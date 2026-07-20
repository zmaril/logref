---
message: "concurrent index creation for exclusion constraints is not supported"
slug: concurrent-index-creation-for-exclusion-constraints-is-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/catalog/index.c:867"
  - "postgres/src/backend/catalog/index.c:1338"
reproduced: false
---

# `concurrent index creation for exclusion constraints is not supported`

## What it means

A `CREATE INDEX CONCURRENTLY` or `ADD CONSTRAINT ... USING INDEX` involved an exclusion constraint, which cannot be built concurrently. Exclusion constraints require a build that concurrent index creation does not support.

## When it happens

Attempting to create an exclusion constraint concurrently, or `CREATE INDEX CONCURRENTLY` on an index backing an exclusion constraint.

## How to fix

Build the exclusion constraint with an ordinary (non-concurrent) `ALTER TABLE ... ADD CONSTRAINT ... EXCLUDE`, accepting the table lock it takes. Schedule it during a maintenance window if the lock is disruptive. Concurrent creation is not available for exclusion constraints.

## Example

*Illustrative* — a concurrent exclusion-constraint build.

```text
ERROR:  concurrent index creation for exclusion constraints is not supported
```

## Related

- [cannot create unique index on partitioned table](./cannot-create-unique-index-on-partitioned-table.md)
- [cannot reindex while reindexing](./cannot-reindex-while-reindexing.md)
