---
message: "publication \"%s\" is defined as FOR ALL TABLES, ALL SEQUENCES"
slug: publication-is-defined-as-for-all-tables-all-sequences
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/publicationcmds.c:1540"
  - "postgres/src/backend/commands/publicationcmds.c:1563"
reproduced: false
---

# `publication "%s" is defined as FOR ALL TABLES, ALL SEQUENCES`

## What it means

An operation tried to change specific-object membership on a publication created `FOR ALL TABLES, ALL SEQUENCES`. That publication covers all tables and sequences, so per-object add/drop does not apply. The placeholder is the publication name.

## When it happens

It arises from `ALTER PUBLICATION ... ADD/DROP/SET` of individual tables or sequences against a publication declared `FOR ALL TABLES, ALL SEQUENCES`.

## How to fix

Do not manage individual objects on an all-objects publication. Create a selectively defined publication if you need to control membership per table or per sequence.

## Example

*Illustrative* — altering members of an all-tables-all-sequences publication.

```text
ERROR:  publication "pub_everything" is defined as FOR ALL TABLES, ALL SEQUENCES
```

## Related

- [publication "%s" is defined as FOR ALL TABLES](./publication-is-defined-as-for-all-tables.md)
- [publication "%s" is defined as FOR ALL SEQUENCES](./publication-is-defined-as-for-all-sequences.md)
