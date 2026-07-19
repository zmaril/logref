---
message: "publication \"%s\" is defined as FOR ALL SEQUENCES"
slug: publication-is-defined-as-for-all-sequences
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/publicationcmds.c:1552"
  - "postgres/src/backend/commands/publicationcmds.c:1575"
reproduced: false
---

# `publication "%s" is defined as FOR ALL SEQUENCES`

## What it means

An operation tried to add or drop specific sequences on a publication that was created `FOR ALL SEQUENCES`. Such a publication already covers every sequence, so per-object membership changes do not apply. The placeholder is the publication name.

## When it happens

It arises from `ALTER PUBLICATION ... ADD/DROP/SET SEQUENCE` against a publication declared `FOR ALL SEQUENCES`.

## How to fix

Do not manage individual sequences on an all-sequences publication. If you need selective membership, create a publication listing specific sequences instead of using `FOR ALL SEQUENCES`.

## Example

*Illustrative* — adding a sequence to an all-sequences publication.

```text
ERROR:  publication "pub_all" is defined as FOR ALL SEQUENCES
```

## Related

- [publication "%s" is defined as FOR ALL TABLES](./publication-is-defined-as-for-all-tables.md)
- [publication "%s" is defined as FOR ALL TABLES, ALL SEQUENCES](./publication-is-defined-as-for-all-tables-all-sequences.md)
