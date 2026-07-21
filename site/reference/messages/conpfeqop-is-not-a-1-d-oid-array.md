---
message: "conpfeqop is not a 1-D Oid array"
slug: conpfeqop-is-not-a-1-d-oid-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_constraint.c:1589"
  - "postgres/src/backend/commands/tablecmds.c:16644"
reproduced: false
---

# `conpfeqop is not a 1-D Oid array`

## What it means

Internal error. Foreign-key catalog code read the `conpfeqop` column of a `pg_constraint` row and found it was not the expected one-dimensional OID array. It is a consistency check on the constraint's stored per-column equality-operator list.

## When it happens

It should not occur through ordinary SQL. Reaching it points to a corrupt or malformed `pg_constraint` row rather than to anything in your command.

## How to fix

Treat it as catalog corruption. Capture the constraint and table involved and report it. If a specific foreign key reproduces it, inspect its `pg_constraint` row; a malformed `conpfeqop` there suggests restoring the catalog from a backup.

## Example

*Illustrative* — a malformed foreign-key catalog array.

```text
ERROR:  conpfeqop is not a 1-D Oid array
```

## Related

- [could not find compatible hash operator for operator](./could-not-find-compatible-hash-operator-for-operator.md)
- [constraint for table does not exist](./constraint-for-table-does-not-exist.md)
