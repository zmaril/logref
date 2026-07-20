---
message: "cannot rewrite table \"%s\" used as a catalog table"
slug: cannot-rewrite-table-used-as-a-catalog-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:6027"
reproduced: false
---

# `cannot rewrite table "%s" used as a catalog table`

## What it means

An operation that rewrites a table's storage targeted a table configured as a user catalog for logical decoding. Such a table's contents must stay readable to decoding, and a rewrite would break that guarantee. The placeholder is the table name.

## When it happens

It occurs when a rewriting `ALTER TABLE` is run on a table set with `user_catalog_table = true`.

## How to fix

Avoid rewriting tables marked as catalog tables for logical decoding. If the change is essential, unset `user_catalog_table`, make the change, and re-establish decoding as needed after confirming no slot depends on the old contents.

## Example

*Illustrative* — rewriting a user catalog table.

```text
ERROR:  cannot rewrite table "my_catalog" used as a catalog table
```

## Related

- [cannot rewrite system relation](./cannot-rewrite-system-relation.md)
- [cannot rewrite temporary tables of other sessions](./cannot-rewrite-temporary-tables-of-other-sessions.md)
