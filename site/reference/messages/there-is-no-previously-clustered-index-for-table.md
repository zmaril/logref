---
message: "there is no previously clustered index for table \"%s\""
slug: there-is-no-previously-clustered-index-for-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/repack.c:407"
  - "postgres/src/backend/commands/repack.c:2498"
reproduced: false
---

# `there is no previously clustered index for table "%s"`

## What it means

A `CLUSTER tablename` was issued without naming an index, and the table has no index previously marked as its clustering index. The placeholder is the table name. Bare `CLUSTER` needs a remembered index to reuse.

## When it happens

It arises from `CLUSTER tablename` (no `USING`) on a table that was never clustered on a specific index, so there is no stored default to cluster by.

## How to fix

Specify the index once with `CLUSTER tablename USING indexname`; that records it as the table's clustering index, after which bare `CLUSTER tablename` reuses it. Choose an index that reflects the physical order you want.

## Example

*Illustrative* — bare CLUSTER on a never-clustered table.

```text
ERROR:  there is no previously clustered index for table "orders"
```

## Related

- [index "%s" for table "%s" does not exist](./index-for-table-does-not-exist.md)
- [relation "%s" is of wrong relation kind](./relation-is-of-wrong-relation-kind.md)
