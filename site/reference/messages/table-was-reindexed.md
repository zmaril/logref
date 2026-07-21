---
message: "table \"%s.%s\" was reindexed"
slug: table-was-reindexed
passthrough: false
api: [ereport]
level: [INFO]
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:3682"
  - "postgres/src/backend/commands/indexcmds.c:4579"
reproduced: false
---

# `table "%s.%s" was reindexed`

## What it means

A reindex operation finished rebuilding all indexes on a table and reports that the table's indexes are done.

## When it happens

It is printed at INFO by `REINDEX TABLE` (and bulk reindex variants) as a per-table completion notice, often alongside timing detail when verbose output is on.

## Is this a problem?

This is a success message, not a problem. No action is needed. It confirms the table's indexes were rebuilt.

## Example

*Illustrative* — a table finishing reindex.

```text
INFO:  table "public.orders" was reindexed
```

## Related

- [skipping reindex of invalid index](./skipping-reindex-of-invalid-index.md)
- [access method does not support multicolumn indexes](./access-method-does-not-support-multicolumn-indexes.md)
