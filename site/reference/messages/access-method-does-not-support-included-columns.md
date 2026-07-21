---
message: "access method \"%s\" does not support included columns"
slug: access-method-does-not-support-included-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:889"
reproduced: true
---

# `access method "%s" does not support included columns`

## What it means

An index definition used the `INCLUDE` clause to add non-key payload columns, but the chosen access method cannot store included columns.

## When it happens

It occurs when creating an index with `INCLUDE (...)` on a method that does not implement covering indexes; only some methods (notably B-tree and GiST) support `INCLUDE`.

## How to fix

Drop the `INCLUDE` clause, or switch to an access method that supports covering indexes. If you need index-only scans over extra columns, use a B-tree index with `INCLUDE`.

## Example

*Reproduced* — captured from `reproducers/scenarios/29_func_index_extension_ddl.sql`.

```sql
CREATE INDEX ON repro.child USING brin (amount) INCLUDE (id);
```

Produces:

```text
ERROR:  access method "brin" does not support included columns
```

## Related

- [access method does not support multicolumn indexes](./access-method-does-not-support-multicolumn-indexes.md)
- [access method already exists](./access-method-already-exists.md)
