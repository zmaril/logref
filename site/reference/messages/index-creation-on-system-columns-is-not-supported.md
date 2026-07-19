---
message: "index creation on system columns is not supported"
slug: index-creation-on-system-columns-is-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:1131"
  - "postgres/src/backend/commands/indexcmds.c:1163"
reproduced: false
---

# `index creation on system columns is not supported`

## What it means

A `CREATE INDEX` names a system column (such as `ctid`, `xmin`, or `tableoid`). Postgres does not allow indexes on system columns, so the command is rejected.

## When it happens

It happens when an index definition references one of the hidden system columns instead of a user column, often by mistake when someone tries to index a physical location such as `ctid`.

## How to fix

Index a user-defined column or an expression over user columns. There is no supported way to build a btree or other index directly on a system column; if you need to locate rows by physical position, that is not something an index provides.

## Example

*Illustrative* — trying to index a system column.

```sql
CREATE INDEX ON t (ctid);  -- rejected
```

## Related

- [index does not belong to table](./index-does-not-belong-to-table.md)
- [is not an index for table](./is-not-an-index-for-table.md)
