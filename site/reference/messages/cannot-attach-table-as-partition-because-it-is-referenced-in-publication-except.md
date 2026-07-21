---
message: "cannot attach table \"%s\" as partition because it is referenced in publication %s EXCEPT clause"
slug: cannot-attach-table-as-partition-because-it-is-referenced-in-publication-except
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:21096"
reproduced: false
---

# `cannot attach table "%s" as partition because it is referenced in publication %s EXCEPT clause`

## What it means

An `ALTER TABLE ... ATTACH PARTITION` was blocked because the table appears in the `EXCEPT` list of a publication that publishes all tables. Attaching it as a partition would conflict with that exclusion, which the command refuses to resolve silently.

## When it happens

It occurs when the table being attached is named in a `CREATE PUBLICATION ... FOR ALL TABLES EXCEPT ...` clause.

## How to fix

Remove the table from the publication's `EXCEPT` list, or drop it from the publication, then attach the partition. Reconcile the publication membership with the partition hierarchy before attaching.

## Example

*Illustrative* — a table excluded from a publication.

```text
ERROR:  cannot attach table "t" as partition because it is referenced in publication p EXCEPT clause
```

## Related

- [cannot attach table as a partition because it is referenced by foreign key](./cannot-attach-table-as-a-partition-because-it-is-referenced-by-foreign-key.md)
- [cannot change table to unlogged because it is part of a publication](./cannot-change-table-to-unlogged-because-it-is-part-of-a-publication.md)
