---
message: "column \"%s\" of relation \"%s\" does not exist"
slug: column-of-relation-does-not-exist-7bb9c5
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:1580"
  - "postgres/src/backend/catalog/catalog.c:709"
  - "postgres/src/backend/catalog/heap.c:2639"
  - "postgres/src/backend/catalog/heap.c:2961"
  - "postgres/src/backend/catalog/objectaddress.c:1627"
  - "postgres/src/backend/catalog/pg_publication.c:697"
  - "postgres/src/backend/commands/analyze.c:1059"
  - "postgres/src/backend/commands/copy.c:1121"
  - "postgres/src/backend/commands/propgraphcmds.c:537"
  - "postgres/src/backend/commands/sequence.c:1658"
  - "postgres/src/backend/commands/tablecmds.c:7900"
  - "postgres/src/backend/commands/tablecmds.c:8078"
  - "postgres/src/backend/commands/tablecmds.c:8279"
  - "postgres/src/backend/commands/tablecmds.c:8408"
  - "postgres/src/backend/commands/tablecmds.c:8562"
  - "postgres/src/backend/commands/tablecmds.c:8656"
  - "postgres/src/backend/commands/tablecmds.c:8759"
  - "postgres/src/backend/commands/tablecmds.c:8919"
  - "postgres/src/backend/commands/tablecmds.c:8949"
  - "postgres/src/backend/commands/tablecmds.c:9104"
  - "postgres/src/backend/commands/tablecmds.c:9207"
  - "postgres/src/backend/commands/tablecmds.c:9341"
  - "postgres/src/backend/commands/tablecmds.c:9454"
  - "postgres/src/backend/commands/tablecmds.c:14942"
  - "postgres/src/backend/commands/tablecmds.c:15145"
  - "postgres/src/backend/commands/tablecmds.c:15306"
  - "postgres/src/backend/commands/tablecmds.c:16702"
  - "postgres/src/backend/commands/tablecmds.c:19467"
  - "postgres/src/backend/commands/trigger.c:959"
  - "postgres/src/backend/parser/analyze.c:1352"
  - "postgres/src/backend/parser/analyze.c:2979"
  - "postgres/src/backend/parser/parse_relation.c:775"
  - "postgres/src/backend/parser/parse_target.c:1073"
  - "postgres/src/backend/parser/parse_type.c:142"
  - "postgres/src/backend/parser/parse_utilcmd.c:3950"
  - "postgres/src/backend/parser/parse_utilcmd.c:3990"
  - "postgres/src/backend/parser/parse_utilcmd.c:4032"
  - "postgres/src/backend/statistics/attribute_stats.c:199"
  - "postgres/src/backend/statistics/attribute_stats.c:637"
  - "postgres/src/backend/utils/adt/acl.c:2967"
  - "postgres/src/backend/utils/adt/ruleutils.c:3216"
  - "postgres/src/pl/plpgsql/src/pl_comp.c:1637"
reproduced: true
---

# `column "%s" of relation "%s" does not exist`

## What it means

A statement named a column that does not exist on the given relation. The first placeholder is the column name, the second the relation. Unlike the bare "column does not exist", this form is used where the relation is already known, so the message can name both.

## When it happens

`ALTER TABLE ... ALTER/DROP/RENAME COLUMN` on a non-existent column, an `INSERT`/`UPDATE` targeting a misspelled column, a `COPY` column list that names a column the table lacks, or referencing a column that was dropped or never added.

## How to fix

Check the column name against `\d relation` (or `information_schema.columns`). Watch for case-folding: an identifier created with double quotes preserves case and must be quoted the same way. If the column was expected to exist, confirm the migration that adds it actually ran against this database.

## Example

*Reproduced* — captured from `reproducers/scenarios/34_guc_vacuum_copy_xml.sql`.

```sql
ANALYZE repro.parent (nonexistent_col);
```

Produces:

```text
ERROR:  column "nonexistent_col" of relation "parent" does not exist
```

## Related

- [column %s.%s does not exist](./column-does-not-exist-056a7f.md)
- [column %d of relation does not exist](./column-of-relation-does-not-exist-df5695.md)
