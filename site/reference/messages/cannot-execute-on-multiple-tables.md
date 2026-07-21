---
message: "cannot execute %s on multiple tables"
slug: cannot-execute-on-multiple-tables
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/repack.c:326"
reproduced: false
---

# `cannot execute %s on multiple tables`

## What it means

A `REPACK` command was given more than one table to act on, but it operates on a single table at a time. The named command does not support a multi-table target. The placeholder is the command name.

## When it happens

It occurs when the command is invoked with several tables in one statement, or against a target that expands to more than one table.

## How to fix

Run the command once per table. Issue a separate statement for each table you want to process.

## Example

*Illustrative* — a command given several tables.

```text
ERROR:  cannot execute REPACK on multiple tables
```

## Related

- [cannot execute on a shared catalog](./cannot-execute-on-a-shared-catalog.md)
- [cannot execute on partitioned table using index with no index name](./cannot-execute-on-partitioned-table-using-index-with-no-index-name.md)
