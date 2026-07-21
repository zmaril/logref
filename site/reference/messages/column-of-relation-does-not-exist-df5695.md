---
message: "column %d of relation \"%s\" does not exist"
slug: column-of-relation-does-not-exist-df5695
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/backend/catalog/dependency.c:2522"
  - "postgres/src/backend/parser/parse_relation.c:3628"
  - "postgres/src/backend/parser/parse_relation.c:3638"
  - "postgres/src/backend/statistics/attribute_stats.c:211"
  - "postgres/src/backend/statistics/stat_utils.c:456"
  - "postgres/src/backend/statistics/stat_utils.c:464"
reproduced: false
---

# `column %d of relation "%s" does not exist`

## What it means

A column referenced by number does not exist on the relation. The first placeholder is the attribute number, the second the relation name. This numeric form is used by statistics and dependency code that identifies columns by position rather than name.

## When it happens

Statistics functions (`pg_stats_ext`, attribute-statistics helpers) or internal code referencing a column position that is out of range for the relation — often after a column was dropped, shifting or invalidating positions, or a stale reference to a former column number.

## How to fix

Re-derive the column reference from the current schema (`pg_attribute.attnum` for existing columns). If a column was dropped, the position may no longer be valid — update whatever produced the number. For statistics tooling, refresh against the current table definition.

## Example

*Illustrative* — a stale column position after a drop.

```text
ERROR:  column 4 of relation "orders" does not exist
```

## Related

- [column %s.%s does not exist](./column-does-not-exist-056a7f.md)
- [column "%s" of relation "%s" does not exist](./column-of-relation-does-not-exist-7bb9c5.md)
