---
message: "cache lookup failed for constraint %u"
slug: cache-lookup-failed-for-constraint
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:3155"
  - "postgres/src/backend/catalog/objectaddress.c:5039"
  - "postgres/src/backend/catalog/objectaddress.c:5278"
  - "postgres/src/backend/catalog/pg_constraint.c:922"
  - "postgres/src/backend/catalog/pg_constraint.c:1015"
  - "postgres/src/backend/catalog/pg_constraint.c:1140"
  - "postgres/src/backend/commands/tablecmds.c:4174"
  - "postgres/src/backend/commands/tablecmds.c:11467"
  - "postgres/src/backend/commands/tablecmds.c:11684"
  - "postgres/src/backend/commands/tablecmds.c:11862"
  - "postgres/src/backend/commands/tablecmds.c:11888"
  - "postgres/src/backend/commands/tablecmds.c:11959"
  - "postgres/src/backend/commands/tablecmds.c:11967"
  - "postgres/src/backend/commands/tablecmds.c:12050"
  - "postgres/src/backend/commands/tablecmds.c:16183"
  - "postgres/src/backend/commands/tablecmds.c:16634"
  - "postgres/src/backend/commands/tablecmds.c:21931"
  - "postgres/src/backend/commands/tablecmds.c:22758"
  - "postgres/src/backend/parser/parse_utilcmd.c:1797"
  - "postgres/src/backend/utils/adt/ri_triggers.c:2451"
  - "postgres/src/backend/utils/adt/ri_triggers.c:2536"
  - "postgres/src/backend/utils/adt/ruleutils.c:7483"
  - "postgres/src/backend/utils/cache/lsyscache.c:1376"
reproduced: false
---

# `cache lookup failed for constraint %u`

## What it means

Internal error. A constraint's catalog row (`pg_constraint`) could not be found by OID. The placeholder is the constraint OID. Something referenced the constraint but the row is gone.

## When it happens

A concurrent drop of a constraint (or of the table/column it protects) while another session still referenced it, or catalog inconsistency. Ordinary data does not cause it.

## How to fix

If it coincides with concurrent DDL on constraints, retry. If it recurs, inspect `pg_constraint` for the OID; a genuinely missing row is catalog corruption. Report reproducible cases with the exact DDL sequence.

## Example

*Illustrative* — a constraint dropped mid-operation.

```text
ERROR:  cache lookup failed for constraint 16571
```

## Related

- [cache lookup failed for relation](./cache-lookup-failed-for-relation-0e5774.md)
- [constraint for relation already exists](./constraint-for-relation-already-exists.md)
