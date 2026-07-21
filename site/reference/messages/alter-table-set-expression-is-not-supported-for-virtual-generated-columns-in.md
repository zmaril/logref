---
message: "ALTER TABLE / SET EXPRESSION is not supported for virtual generated columns in tables that are part of a publication"
slug: alter-table-set-expression-is-not-supported-for-virtual-generated-columns-in
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:8792"
reproduced: false
---

# `ALTER TABLE / SET EXPRESSION is not supported for virtual generated columns in tables that are part of a publication`

## What it means

An `ALTER TABLE ... ALTER COLUMN ... SET EXPRESSION` targeted a virtual generated column on a table that is part of a publication, a combination that is not supported.

## When it happens

It occurs when changing the generation expression of a virtual generated column on a table included in a logical-replication publication.

## How to fix

Remove the table from the publication before changing the virtual generated column's expression, or avoid altering the expression of virtual generated columns on published tables. Adjust the publication membership and generated columns so they are consistent with replication.

## Example

*Illustrative* — setting a virtual generated column expression on a published table.

```sql
ALTER TABLE t ALTER COLUMN g SET EXPRESSION AS (a + 1);  -- t is in a publication
```

## Related

- [alter table / drop expression is not supported for virtual generated columns](./alter-table-drop-expression-is-not-supported-for-virtual-generated-columns.md)
- [alter subscription refresh publication with copy_data is not allowed when two_phase is enabled](./alter-subscription-refresh-publication-with-copy-data-is-not-allowed-when-two.md)
