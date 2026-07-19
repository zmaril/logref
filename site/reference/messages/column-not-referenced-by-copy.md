---
message: "%s column \"%s\" not referenced by COPY"
slug: column-not-referenced-by-copy
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
call_sites:
  - "postgres/src/backend/commands/copyfrom.c:1614"
  - "postgres/src/backend/commands/copyfrom.c:1674"
  - "postgres/src/backend/commands/copyto.c:1114"
reproduced: false
---

# `%s column "%s" not referenced by COPY`

## What it means

A `COPY` option (such as `FORCE NOT NULL`, `FORCE NULL`, or `FORCE QUOTE`) named a column that is not in the `COPY` column list. The placeholders name the option context and the column. These per-column options may only apply to columns actually being copied.

## When it happens

Listing a column in `FORCE QUOTE`/`FORCE NOT NULL`/`FORCE NULL` that was omitted from the `COPY (col_list)` — or misspelled — so the option targets a column the copy does not touch.

## How to fix

Reference only columns that appear in the `COPY` column list. Add the column to the copy list if it should be included, or remove it from the force option. Use `FORCE QUOTE *` if you meant all columns. Check spelling and case.

## Example

*Illustrative* — a force option on an uncopied column.

```sql
COPY t (a) TO STDOUT WITH (FORMAT csv, FORCE_QUOTE (b));  -- column "b" not referenced by COPY
```

## Related

- [extra data after last expected column](./extra-data-after-last-expected-column.md)
- [column named in key does not exist](./column-named-in-key-does-not-exist.md)
