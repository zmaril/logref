---
message: "could not find attrdef tuple for relation %u attnum %d"
slug: could-not-find-attrdef-tuple-for-relation-attnum
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_attrdef.c:197"
  - "postgres/src/backend/commands/tablecmds.c:8834"
  - "postgres/src/backend/commands/tablecmds.c:9015"
  - "postgres/src/backend/commands/tablecmds.c:15544"
reproduced: false
---

# `could not find attrdef tuple for relation %u attnum %d`

## What it means

Internal error. Code looked in `pg_attrdef` for the stored default expression of a specific column (by relation OID and attribute number) and did not find the expected row. The placeholders are the relation OID and the attribute number. It is a consistency check between a column's `atthasdef` flag and its default row.

## When it happens

It should not occur for normally-defined defaults. Reaching it points to catalog inconsistency between `pg_attribute` and `pg_attrdef`, or a bug, not to your SQL.

## How to fix

Treat it as an internal bug or catalog corruption. If it recurs on a specific table/column, try dropping and re-adding the column default (`ALTER TABLE ... ALTER COLUMN ... DROP/SET DEFAULT`). Capture the case and report it.

## Example

*Illustrative* — emitted internally reading a column default.

```text
ERROR:  could not find attrdef tuple for relation 16400 attnum 2
```

## Related

- [default expression not found for attribute of relation](./default-expression-not-found-for-attribute-of-relation.md)
- [attribute of relation does not exist](./attribute-of-relation-does-not-exist.md)
