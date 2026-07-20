---
message: "cannot use system column \"%s\" in publication column list"
slug: cannot-use-system-column-in-publication-column-list
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
call_sites:
  - "postgres/src/backend/catalog/pg_publication.c:703"
reproduced: false
---

# `cannot use system column "%s" in publication column list`

## What it means

A publication column list named a system column such as `ctid` or `xmin`. Publications replicate user columns, so a system column cannot be part of the published column list.

## When it happens

It occurs on `CREATE PUBLICATION` or `ALTER PUBLICATION` when the per-table column list includes a system column.

## How to fix

List only user columns in the publication column list. Remove the system column and publish ordinary data columns.

## Example

*Illustrative* — a system column in a column list.

```text
ERROR:  cannot use system column "xmin" in publication column list
```

## Related

- [cannot use system column in MERGE WHEN condition](./cannot-use-system-column-in-merge-when-condition.md)
- [cannot use publication WHERE clause for relation](./cannot-use-publication-where-clause-for-relation.md)
