---
message: "could not find parent table of index \"%s\""
slug: could-not-find-parent-table-of-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_TABLE
    code: "42P01"
call_sites:
  - "postgres/contrib/pg_prewarm/pg_prewarm.c:144"
reproduced: false
---

# `could not find parent table of index "%s"`

## What it means

`pg_prewarm` was asked to prewarm an index but could not find the table the index belongs to. The `%s` names the index. Without its parent table the index cannot be prewarmed.

## When it happens

It happens when calling `pg_prewarm` on an index whose parent table cannot be located, usually because the object identifier does not refer to a valid index, or it was dropped concurrently.

## How to fix

Pass a valid index to `pg_prewarm`, and confirm it and its table still exist. Check the identifier you supplied resolves to an index in the current database.

## Example

*Illustrative* — prewarming an index with no findable parent.

```sql
SELECT pg_prewarm('missing_idx');
-- ERROR:  could not find parent table of index "missing_idx"
```

## Related

- [could not find pg_class tuple for index](./could-not-find-pg-class-tuple-for-index.md)
- [could not find index attname](./could-not-find-index-attname.md)
