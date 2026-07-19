---
message: "access method \"%s\" does not support NULLS FIRST/LAST options"
slug: access-method-does-not-support-nulls-first-last-options
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:2266"
reproduced: false
---

# `access method "%s" does not support NULLS FIRST/LAST options`

## What it means

An index definition used `NULLS FIRST` or `NULLS LAST`, but the chosen access method does not order rows, so the placement of nulls in the ordering has no meaning for it.

## When it happens

It occurs when creating an index with an explicit nulls-ordering clause on a non-ordered method like GIN, GiST, BRIN, or hash.

## How to fix

Remove the `NULLS FIRST`/`NULLS LAST` clause for that access method. Only ordered methods (B-tree) support null ordering; use a B-tree index if you need it.

## Example

*Illustrative* — a nulls-ordering clause on a non-ordered method.

```sql
CREATE INDEX ON t USING brin (c NULLS FIRST);  -- brin does not order rows
```

## Related

- [access method does not support ASC/DESC options](./access-method-does-not-support-asc-desc-options.md)
- [access method does not support ordering operators](./access-method-does-not-support-ordering-operators.md)
