---
message: "null conbin for relation \"%s\""
slug: null-conbin-for-relation
passthrough: false
api: [elog]
level: [ERROR, WARNING]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:15857"
  - "postgres/src/backend/utils/cache/relcache.c:4676"
reproduced: false
---

# `null conbin for relation "%s"`

## What it means

Internal error. A check constraint's stored binary expression (`conbin`) is null for a relation that should have one. The placeholder is the relation name. It is a consistency guard over `pg_constraint`.

## When it happens

It fires when the system reads a check constraint whose compiled expression is missing. A normally defined check constraint always stores one; this points to corrupted catalog data or an internal inconsistency.

## How to fix

This is a can't-happen guard. If a specific relation triggers it, its constraint metadata may be damaged — inspect with `\d+` and consider dropping and recreating the affected check constraint. Capture the definition and report a reproducible case.

## Example

*Illustrative* — a check constraint missing its expression.

```text
ERROR:  null conbin for relation "my_table"
```

## Related

- [no generation expression found for column number of table](./no-generation-expression-found-for-column-number-of-table.md)
- [null ACL](./null-acl.md)
