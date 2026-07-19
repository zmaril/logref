---
message: "cannot use virtual generated column \"%s\" in publication column list"
slug: cannot-use-virtual-generated-column-in-publication-column-list
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
call_sites:
  - "postgres/src/backend/catalog/pg_publication.c:709"
reproduced: false
---

# `cannot use virtual generated column "%s" in publication column list`

## What it means

A publication column list named a virtual generated column. A virtual generated column stores no data of its own; its value is computed on read, so it has nothing to replicate and cannot be listed.

## When it happens

It occurs on `CREATE PUBLICATION` or `ALTER PUBLICATION` when the per-table column list includes a `GENERATED ALWAYS AS (...) VIRTUAL` column.

## How to fix

Remove the virtual generated column from the column list. Publish only stored columns, and recompute the derived value on the subscriber if it is needed there.

## Example

*Illustrative* — a virtual generated column in a column list.

```text
ERROR:  cannot use virtual generated column "g" in publication column list
```

## Related

- [cannot use system column in publication column list](./cannot-use-system-column-in-publication-column-list.md)
- [cannot use whole-row variable in column generation expression](./cannot-use-whole-row-variable-in-column-generation-expression.md)
