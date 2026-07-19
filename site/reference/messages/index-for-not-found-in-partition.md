---
message: "index for %u not found in partition %s"
slug: index-for-not-found-in-partition
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:11115"
  - "postgres/src/backend/commands/tablecmds.c:11534"
reproduced: false
---

# `index for %u not found in partition %s`

## What it means

Internal error. While maintaining partitioned-index relationships, the code expected to find the child index matching a given parent index OID on a partition and did not. It is a consistency guard over `pg_index`/partition metadata.

## When it happens

It fires during partition attach/detach or index maintenance when a partition is missing the child index that should correspond to a partitioned parent index. Ordinary queries do not surface it.

## How to fix

This is an internal guard. If it coincides with concurrent DDL on partitions or indexes, retry. If it recurs, inspect the partitioned index tree with `\d+` on the parent index and check for a partition left without its expected child; report a reproducible case.

## Example

*Illustrative* — a partition missing an expected child index.

```text
ERROR:  index for 16412 not found in partition child_p3
```

## Related

- [index does not belong to table](./index-does-not-belong-to-table.md)
- [is a partitioned table](./is-a-partitioned-table.md)
