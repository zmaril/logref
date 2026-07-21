---
message: "cannot execute %s on partitioned table \"%s\" USING INDEX with no index name"
slug: cannot-execute-on-partitioned-table-using-index-with-no-index-name
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/repack.c:412"
reproduced: false
---

# `cannot execute %s on partitioned table "%s" USING INDEX with no index name`

## What it means

A `REPACK` on a partitioned table asked to order by an index but did not name the index. On a partitioned table each partition has its own physical index, so the command needs an explicit index name to resolve the right one per partition. The placeholders are the command and table names.

## When it happens

It occurs when you run the command with a `USING INDEX` clause against a partitioned table but omit the index name.

## How to fix

Name the index explicitly in the `USING INDEX` clause, or run the command on individual partitions where the index is unambiguous.

## Example

*Illustrative* — a partitioned target with no named index.

```text
ERROR:  cannot execute REPACK on partitioned table "orders" USING INDEX with no index name
```

## Related

- [cannot execute on multiple tables](./cannot-execute-on-multiple-tables.md)
- [cannot execute in this configuration](./cannot-execute-in-this-configuration.md)
