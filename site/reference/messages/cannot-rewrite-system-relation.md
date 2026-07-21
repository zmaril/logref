---
message: "cannot rewrite system relation \"%s\""
slug: cannot-rewrite-system-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:6021"
reproduced: false
---

# `cannot rewrite system relation "%s"`

## What it means

An operation that rewrites a table's storage targeted a system catalog. Rewriting rebuilds the relation's files, and system catalogs cannot be rewritten this way. The placeholder is the relation name.

## When it happens

It occurs when a rewriting `ALTER TABLE` (such as a type change or `SET ACCESS METHOD`) is run against a system catalog.

## How to fix

Do not run rewriting operations on system catalogs. If a catalog needs maintenance, use the supported paths (`VACUUM`, `REINDEX`), which do not require a user-driven rewrite.

## Example

*Illustrative* — rewriting a system catalog.

```text
ERROR:  cannot rewrite system relation "pg_class"
```

## Related

- [cannot rewrite table used as a catalog table](./cannot-rewrite-table-used-as-a-catalog-table.md)
- [cannot rewrite temporary tables of other sessions](./cannot-rewrite-temporary-tables-of-other-sessions.md)
