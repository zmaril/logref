---
message: "access method \"%s\" does not support ASC/DESC options"
slug: access-method-does-not-support-asc-desc-options
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:2260"
reproduced: false
---

# `access method "%s" does not support ASC/DESC options`

## What it means

An index definition used `ASC` or `DESC` on a column, but the chosen index access method does not implement ordered scans, so per-column sort direction is meaningless for it.

## When it happens

It occurs when creating an index with an explicit sort direction on a method like GIN, GiST, BRIN, or hash, which do not return rows in a defined order.

## How to fix

Remove the `ASC`/`DESC` clause from the index columns for that access method. Only ordered methods (notably B-tree) support per-column direction; if you need ordered scans, use a B-tree index.

## Example

*Illustrative* — a sort direction on a non-ordered index method.

```sql
CREATE INDEX ON t USING gin (col ASC);  -- gin does not support ASC/DESC
```

## Related

- [access method does not support NULLS FIRST/LAST options](./access-method-does-not-support-nulls-first-last-options.md)
- [access method does not support ordering operators](./access-method-does-not-support-ordering-operators.md)
