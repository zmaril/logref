---
message: "index row requires %zu bytes, maximum size is %zu"
slug: index-row-requires-bytes-maximum-size-is
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/access/common/indextuple.c:207"
  - "postgres/src/backend/access/spgist/spgutils.c:975"
reproduced: false
---

# `index row requires %zu bytes, maximum size is %zu`

## What it means

A value being indexed produced an index entry larger than a btree page can hold. Btree limits each index tuple to roughly a third of a page (about 2704 bytes by default), and this row exceeds it.

## When it happens

It happens when inserting or updating a row whose indexed column (or the combined key of a multi-column index) is very large — long text, large arrays, or wide composite keys — into a btree index.

## How to fix

Index a derived, shorter value instead of the whole column. Common options: index an expression like `md5(col)` or `left(col, N)` for equality lookups, or use a GIN index (for example with `pg_trgm`) for text search, since GIN does not have the per-tuple size limit. Reserve btree for keys that stay within the size bound.

## Example

*Illustrative* — indexing an over-long text value.

```text
ERROR:  index row requires 3016 bytes, maximum size is 2704
```

## Related

- [number of columns exceeds limit](./number-of-columns-exceeds-limit.md)
- [index out of valid range 0](./index-out-of-valid-range-0.md)
