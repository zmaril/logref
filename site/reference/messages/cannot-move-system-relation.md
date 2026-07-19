---
message: "cannot move system relation \"%s\""
slug: cannot-move-system-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/catalog/index.c:3775"
  - "postgres/src/backend/commands/indexcmds.c:3820"
  - "postgres/src/backend/commands/indexcmds.c:3966"
  - "postgres/src/backend/commands/tablecmds.c:3790"
reproduced: false
---

# `cannot move system relation "%s"`

## What it means

A request to move a relation to another tablespace targeted a system catalog. The placeholder is the relation name. System relations must stay in their designated tablespace, so relocating them is not permitted.

## When it happens

Running `ALTER TABLE ... SET TABLESPACE` (or `ALTER INDEX`, or a `REINDEX` with a tablespace) on a `pg_catalog` relation, or an `ALTER DATABASE ... SET TABLESPACE`/`ALTER TABLESPACE ... MOVE` that would relocate system relations.

## How to fix

Do not move system catalogs — only user relations may be relocated. If you are trying to move all objects, use a form that excludes system relations. To place user data on another tablespace, `SET TABLESPACE` those specific tables and indexes.

## Example

*Illustrative* — moving a system catalog.

```sql
ALTER TABLE pg_class SET TABLESPACE fast;
```

## Related

- [cannot retrieve a system column in this context](./cannot-retrieve-a-system-column-in-this-context.md)
- [tablespace does not exist](./tablespace-does-not-exist.md)
