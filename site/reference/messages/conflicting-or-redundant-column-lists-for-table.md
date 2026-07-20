---
message: "conflicting or redundant column lists for table \"%s\""
slug: conflicting-or-redundant-column-lists-for-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/commands/publicationcmds.c:1881"
  - "postgres/src/backend/commands/publicationcmds.c:1950"
reproduced: false
---

# `conflicting or redundant column lists for table "%s"`

## What it means

A publication command gave a table more than one column list, or a column list that duplicates an existing one. The placeholder is the table name. A table may appear in a publication with a single column list, not conflicting or repeated ones.

## When it happens

`CREATE`/`ALTER PUBLICATION` that adds the same table twice with different column lists, or in a way that duplicates a column list already set for it.

## How to fix

Give the table one column list in the publication. Combine the intended columns into a single list and remove the duplicate or conflicting entry. Use `ALTER PUBLICATION ... SET TABLE` to replace an existing list cleanly.

## Example

*Illustrative* — two column lists for one table.

```text
ERROR:  conflicting or redundant column lists for table "orders"
```

## Related

- [conflicting or redundant WHERE clauses for table](./conflicting-or-redundant-where-clauses-for-table.md)
- [cannot use column list for relation in publication](./cannot-use-column-list-for-relation-in-publication.md)
