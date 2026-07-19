---
message: "default expression not found for attribute %d of relation \"%s\""
slug: default-expression-not-found-for-attribute-of-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:2924"
  - "postgres/src/backend/commands/tablecmds.c:23055"
  - "postgres/src/backend/parser/parse_utilcmd.c:1418"
  - "postgres/src/backend/rewrite/rewriteHandler.c:1305"
reproduced: false
---

# `default expression not found for attribute %d of relation "%s"`

## What it means

Internal error. Table-command code expected a stored default expression for a column (by attribute number) and did not find one where the catalog said it should be. The placeholders are the attribute number and the relation name. It is a consistency check on a column's default handling.

## When it happens

It should not occur for normally-defined tables. Reaching it points to catalog inconsistency around column defaults, or a bug, not to your SQL.

## How to fix

Treat it as an internal bug or catalog corruption. If it recurs on a specific table/column, try dropping and re-setting the column default. Capture the table definition and the failing operation and report it.

## Example

*Illustrative* — emitted internally handling a column default.

```text
ERROR:  default expression not found for attribute 3 of relation "t"
```

## Related

- [could not find attrdef tuple for relation attnum](./could-not-find-attrdef-tuple-for-relation-attnum.md)
- [attribute of relation does not exist](./attribute-of-relation-does-not-exist.md)
