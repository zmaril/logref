---
message: "cannot attach table \"%s\" as a partition because it is referenced by foreign key \"%s\""
slug: cannot-attach-table-as-a-partition-because-it-is-referenced-by-foreign-key
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:11619"
reproduced: false
---

# `cannot attach table "%s" as a partition because it is referenced by foreign key "%s"`

## What it means

An `ALTER TABLE ... ATTACH PARTITION` was blocked because the table being attached is the target of a foreign key from another table. Attaching it as a partition would change how those references are enforced in a way the command does not allow.

## When it happens

It occurs when a foreign key elsewhere references the table you are trying to attach as a partition.

## How to fix

Drop the referencing foreign key, attach the partition, then recreate the foreign key against the partitioned parent instead of the individual partition. Foreign keys should point at the partitioned table, not at a leaf that is about to become a partition.

## Example

*Illustrative* — a referenced table being attached.

```text
ERROR:  cannot attach table "t" as a partition because it is referenced by foreign key "fk"
```

## Related

- [cannot attach table as partition because it is referenced in publication except](./cannot-attach-table-as-partition-because-it-is-referenced-in-publication-except.md)
- [cannot attach foreign table as partition of partitioned table](./cannot-attach-foreign-table-as-partition-of-partitioned-table.md)
