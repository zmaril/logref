---
message: "conflicting or redundant WHERE clauses for table \"%s\""
slug: conflicting-or-redundant-where-clauses-for-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/commands/publicationcmds.c:1874"
  - "postgres/src/backend/commands/publicationcmds.c:1938"
reproduced: false
---

# `conflicting or redundant WHERE clauses for table "%s"`

## What it means

A publication command gave a table more than one row filter (`WHERE`) clause, or one that duplicates an existing filter. The placeholder is the table name. A table may have a single row filter within a publication.

## When it happens

`CREATE`/`ALTER PUBLICATION` that adds the same table with two different `WHERE` clauses, or repeats a filter the table already has.

## How to fix

Provide one row filter per table in the publication. Merge the conditions into a single `WHERE` clause and drop the duplicate. Use `ALTER PUBLICATION ... SET TABLE ... WHERE (...)` to replace the existing filter.

## Example

*Illustrative* — two WHERE clauses for one table.

```text
ERROR:  conflicting or redundant WHERE clauses for table "orders"
```

## Related

- [conflicting or redundant column lists for table](./conflicting-or-redundant-column-lists-for-table.md)
- [cannot set parameter to false for publication](./cannot-set-parameter-to-false-for-publication.md)
