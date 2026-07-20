---
message: "cannot use column list for relation \"%s.%s\" in publication \"%s\""
slug: cannot-use-column-list-for-relation-in-publication
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/publicationcmds.c:808"
  - "postgres/src/backend/commands/publicationcmds.c:822"
reproduced: false
---

# `cannot use column list for relation "%s.%s" in publication "%s"`

## What it means

A publication defined a column list for a table where a column list is not allowed. The placeholders are the schema-qualified table and the publication. Column lists conflict with certain publication settings — for example when the publication replicates via the partition root, or when a later definition contradicts an earlier one.

## When it happens

Adding a table with a column list to a publication whose options (such as `publish_via_partition_root`) or existing membership make a per-column list invalid.

## How to fix

Publish the whole row without a column list, or adjust the publication so a column list is permitted. Review the publication's options and any existing entry for the table; a column list must be consistent with them.

## Example

*Illustrative* — a column list where it is not allowed.

```text
ERROR:  cannot use column list for relation "public.orders" in publication "p"
```

## Related

- [conflicting or redundant column lists for table](./conflicting-or-redundant-column-lists-for-table.md)
- [cannot add schema to publication](./cannot-add-schema-to-publication-d50742.md)
