---
message: "index \"%s\" does not belong to table \"%s\""
slug: index-does-not-belong-to-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/catalog/catalog.c:701"
  - "postgres/src/backend/parser/parse_utilcmd.c:2451"
reproduced: false
---

# `index "%s" does not belong to table "%s"`

## What it means

A command referenced an index together with a table, but the named index is not an index on that table. The two objects do not have the parent/child relationship the command requires.

## When it happens

It arises in operations that take both a table and one of its indexes — for example `ALTER TABLE ... ATTACH PARTITION` index matching, `ALTER INDEX ... ATTACH`, or clustering — when the index named belongs to a different table.

## How to fix

Name an index that actually belongs to the target table. Use `\d tablename` in psql to list a table's indexes, and pass one of those. Check for a copy/paste error where an index from another table was used.

## Example

*Illustrative* — pairing a table with an unrelated index.

```sql
ALTER TABLE parent ATTACH PARTITION child ...;  -- child index belongs elsewhere
```

## Related

- [is not an index for table](./is-not-an-index-for-table.md)
- [index creation on system columns is not supported](./index-creation-on-system-columns-is-not-supported.md)
