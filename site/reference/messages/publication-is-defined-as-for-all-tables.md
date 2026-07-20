---
message: "publication \"%s\" is defined as FOR ALL TABLES"
slug: publication-is-defined-as-for-all-tables
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/publicationcmds.c:1546"
  - "postgres/src/backend/commands/publicationcmds.c:1569"
reproduced: false
---

# `publication "%s" is defined as FOR ALL TABLES`

## What it means

An operation tried to add or drop specific tables on a publication created `FOR ALL TABLES`. That publication already includes every table, so per-table membership changes are not allowed. The placeholder is the publication name.

## When it happens

It arises from `ALTER PUBLICATION ... ADD/DROP/SET TABLE` against a publication declared `FOR ALL TABLES`.

## How to fix

Do not manage individual tables on an all-tables publication. If you need selective membership, create a publication that lists specific tables rather than using `FOR ALL TABLES`.

## Example

*Illustrative* — adding a table to an all-tables publication.

```text
ERROR:  publication "pub_all" is defined as FOR ALL TABLES
```

## Related

- [publication "%s" is defined as FOR ALL SEQUENCES](./publication-is-defined-as-for-all-sequences.md)
- [publication "%s" already exists](./publication-already-exists.md)
