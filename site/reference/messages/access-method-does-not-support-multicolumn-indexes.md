---
message: "access method \"%s\" does not support multicolumn indexes"
slug: access-method-does-not-support-multicolumn-indexes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:894"
reproduced: true
---

# `access method "%s" does not support multicolumn indexes`

## What it means

An index was defined over more than one key column, but the chosen access method only supports single-column indexes.

## When it happens

It occurs when creating an index with several key columns on a method that is single-column only, such as BRIN in some configurations or hash.

## How to fix

Create separate single-column indexes, or use an access method that supports multiple key columns (B-tree, GiST, GIN, BRIN as applicable). Reduce the index to one key column for the method you chose.

## Example

*Reproduced* — captured from `reproducers/scenarios/29_func_index_extension_ddl.sql`.

```sql
CREATE INDEX ON repro.child USING hash (amount, id);
```

Produces:

```text
ERROR:  access method "hash" does not support multicolumn indexes
```

## Related

- [access method does not support included columns](./access-method-does-not-support-included-columns.md)
- [access method does not support unique indexes](./access-method-does-not-support-unique-indexes.md)
