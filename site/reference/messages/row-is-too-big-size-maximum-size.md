---
message: "row is too big: size %zu, maximum size %zu"
slug: row-is-too-big-size-maximum-size
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/access/heap/hio.c:531"
  - "postgres/src/backend/access/heap/rewriteheap.c:642"
reproduced: false
---

# `row is too big: size %zu, maximum size %zu`

## What it means

An attempt to store a row failed because its on-page size exceeds the maximum a single heap page can hold after out-of-line (TOAST) storage was already applied. The placeholders are the row size and the maximum. Even with large values pushed out of line, the remaining row is too big for a page.

## When it happens

It arises on `INSERT`/`UPDATE` of a row with many columns whose non-TOASTable portions together exceed the ~8 KB page limit — commonly very wide tables with many fixed-width or non-compressible columns.

## How to fix

Reduce the row's on-page footprint: split the table so fewer columns live together, move large text/bytea into columns that can be TOASTed, or normalize wide data into a related table. The per-row page limit is fixed by the block size.

## Example

*Illustrative* — a row too large to fit a page even after TOAST.

```text
ERROR:  row is too big: size 9200, maximum size 8160
```

## Related

- [too many array dimensions](./too-many-array-dimensions.md)
- [total size of jsonb array elements exceeds the maximum of %d bytes](./total-size-of-jsonb-array-elements-exceeds-the-maximum-of-bytes.md)
