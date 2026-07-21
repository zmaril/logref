---
message: "invalid connectby return type"
slug: invalid-connectby-return-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/contrib/tablefunc/tablefunc.c:1422"
  - "postgres/contrib/tablefunc/tablefunc.c:1432"
  - "postgres/contrib/tablefunc/tablefunc.c:1440"
  - "postgres/contrib/tablefunc/tablefunc.c:1449"
  - "postgres/contrib/tablefunc/tablefunc.c:1456"
  - "postgres/contrib/tablefunc/tablefunc.c:1495"
  - "postgres/contrib/tablefunc/tablefunc.c:1508"
reproduced: false
---

# `invalid connectby return type`

## What it means

The `connectby` function from the `tablefunc` extension was called with a column definition whose types do not match what `connectby` produces. The output columns (keyid, parent_keyid, level, and optionally branch/serial) have specific types, and the supplied `AS (...)` list disagrees.

## When it happens

Calling `connectby(...)` with an `AS (col type, ...)` list that has the wrong types or wrong number of columns for the hierarchy output — for example declaring an `int` keyid where the key column is `text`.

## How to fix

Match the column definition list to `connectby`'s output: the key and parent-key columns must match your table's key type, `level` is `int`, and the optional branch column is `text`. Consult the `tablefunc` documentation for the exact output shape and align your `AS (...)` list to it.

## Example

*Illustrative* — a connectby call with mismatched output types.

```sql
SELECT * FROM connectby('t','id','parent','1',0)
  AS t(id int, parent int, level int);   -- but id is text
```

Produces:

```text
ERROR:  invalid connectby return type
```

## Related

- [return type must be a row type](./return-type-must-be-a-row-type.md)
- [table row type and query-specified row type do not match](./table-row-type-and-query-specified-row-type-do-not-match.md)
